//
//  HGGroupMemberController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/21/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON

private let ID = "user_cell"

private let headers = ["团长大人","成员"]

class HGGroupMemberController: UIViewController {

    var model: HGGroupModel!
    
    var users: [HGPersonModel] = []
    var creators: [HGPersonModel] = []
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        self.buildTableView()
        print("creator = \(self.model.creator)")
        self.fectchAllUsersByGroupID(self.model.groupid)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}


extension HGGroupMemberController: UITableViewDataSource,UITableViewDelegate {
    
    func buildTableView() -> Void {
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.view.addSubview(self.tableView)
        
        self.tableView.registerNib(UINib.init(nibName: "HGUserCell", bundle: nil), forCellReuseIdentifier: ID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? self.creators.count : self.users.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ID) as! HGUserCell
        if indexPath.section == 0 {
            
            cell.userIcon.sd_setImageWithURL(NSURL(string: self.creators[0].portraitUri))
            cell.userName.text = self.creators[0].name
            
        } else {
            
            cell.userIcon.sd_setImageWithURL(NSURL(string: self.users[indexPath.row].portraitUri))
            cell.userName.text = self.users[indexPath.row].name
            
        }
        
        return cell
    }
    

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 1 && self.users.count == 0 {
            return nil
        }
        
        return headers[section]
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 44
    }
        

}

extension HGGroupMemberController {
    
    //获取指定groupid的团的成员
    
    func fectchAllUsersByGroupID(groupID: String) {
        
        Alamofire.request(.POST, HGFlags.IM_allUsers, parameters: ["groupid": groupID], encoding: .URL, headers: [: ]).validate().responseJSON{
                response in
            switch response.result {
                
                case .Success:
                    if let value = response.result.value {
                    
                        let json = JSON(value)
                        let status = json["status"].int!
                    
                        switch status {
                        
                        //成功获取数据
                        case 1:
                            let items = json["users"].array!
                            var results: [HGPersonModel] = []
                            var creators: [HGPersonModel] = []
                            for item in items {
                                
                                let dict = item.dictionaryObject!
                                let user = HGPersonModel.personWithDict(dict)
                                print("------members----\(user.name)")
                                if user.userid == self.model.creator {
                                    
                                    creators.append(user)
                                } else {
                                    results.append(user)
                                }
                            }
                            self.creators = creators
                            self.users = results
                            self.tableView.reloadData()
                        
                        //没有获取数据，默认不处理
                        default:
                        
                            break
                        
                        }
                    
                    }
                
                case .Failure:
                
                    print("failure")
                    //什么也不处理
                }
            
        }
    
    }


}







