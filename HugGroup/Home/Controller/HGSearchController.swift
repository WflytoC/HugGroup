//
//  HGSearchController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/19/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Toast
import SwiftyJSON
import SDWebImage

private let ID = "detail_cell"

class HGSearchController: UIViewController {

    var tableView: UITableView!
    
    var type: String?
    
    var page: Int = 1
    
    var models: [HGGroupModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.buildTableView()
        SVProgressHUD.showWithStatus("加载中....")
        self.startSearchGroup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

extension HGSearchController: UITableViewDataSource,UITableViewDelegate {
    
    func buildTableView() {
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Plain)
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib.init(nibName: "HGDetailCell", bundle: nil), forCellReuseIdentifier: ID)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.models.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ID) as! HGDetailCell
        let model = self.models[indexPath.row]
        cell.groupIcon.sd_setImageWithURL(NSURL(string: model.groupportraituri))
        cell.groupName.text = model.groupname
        cell.groupInfo.text = model.groupinfo
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.models[indexPath.row]
        //跳出提示框

        let alert = UIAlertController(title: "提示", message: "需要加入该团吗?", preferredStyle: .Alert)
        let act1 = UIAlertAction(title: "确定", style: .Default) { action in
            
            self.joinGroup(model.groupid, group: model, groupName: model.groupname)
            
            print("group info =\(model.groupinfo)")
        }
        let act2 = UIAlertAction(title: "取消", style: .Cancel) {
            action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addAction(act1)
        alert.addAction(act2)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}

extension HGSearchController {
    
    func startSearchGroup() -> Void {
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
    
        Alamofire.request(.POST, HGFlags.IM_searchTargets, parameters: ["groupclass": self.type!,"page": self.page,"num": 10], encoding: .URL, headers: [: ]).validate().responseJSON { response in
                
                SVProgressHUD.dismiss()
                switch response.result {
    
                    case .Success:
                        if let value = response.result.value {
    
    
                            let json = JSON(value)
                            let status = json["status"].int!
                            switch status {
    
                                case 1 :
                                
                                    print(json)
                                
                                    var models: [HGGroupModel] = []
                                    let arrs = json["groups"].array!
                                    for item in arrs {
                                        
                                        let model = HGGroupModel.groupWithDict(item.dictionaryObject)
                                        models.append(model)
                                        
                                }
                                self.models = models
                                self.tableView.reloadData()
                                
                                default:
                                    self.view.makeToast("该类别下还没有团", duration: 2.0, position: CSToastPositionCenter, style: style)
                                
                            }
                        }
    
                    case .Failure(let error):
    
                        self.view.makeToast("网络出现问题", duration: 2.0, position: CSToastPositionCenter, style: style)
                            print(error)
            }
    
        }

    }
    
    
    
    func joinGroup(groupId: String,group: HGGroupModel,groupName: String) {
        
        let groupOption = HGDataBaseManager.shareInstance().getGroupByGroupId(groupId)
        if let _ = groupOption {
            
            self.view.makeToast("您已经是该团成员")
            return
        }
        
        SVProgressHUD.showWithStatus("加群中....")
        //申请加入团
        Alamofire.request(.POST, HGFlags.IM_addGroup, parameters: ["groupid": groupId,"groupname": groupName,"userid": HGUtils.valueFromKey(HGFlags.ud_phone)!], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    print("add group \(json.description)")
                    let status = json["status"].int!
                    
                    switch status {
                        
                    //成功获取数据
                    case 1:
                        
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            HGUtils.logGroupCount()
                            
                            print("add group \(group.groupinfo)")
                            HGDataBaseManager.shareInstance().insertGroupToDB(group)
                            
                            HGUtils.logGroupCount()
                            
                            self.view.makeToast("您成功加入该团")
                        })
                    //没有获取数据，默认不处理
                    default:
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.view.makeToast("加团失败")
                        })
                        break
                        
                    }
                    
                }
                
            case .Failure:
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.view.makeToast("加团失败")
                })
                //什么也不处理
            }
            
        }
        
        
        //
    }


    
}


