//
//  HGGroupController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/16/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SDWebImage

private let ID = "group_cell"

class HGGroupController: UIViewController {

    var tableView: UITableView!
    
    //根据拼音排好序
    var groups: [[HGGroupModel]] = []
    
    //取出首字母数组
    var indexArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib.init(nibName: "HGGroupCell", bundle: nil), forCellReuseIdentifier: ID)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let groups = HGDataBaseManager.shareInstance().getAllGroups() as! [HGGroupModel]
        
        HGUtils.logGroupCount()
        
        (self.groups,self.indexArray) = self.sortByLetter(groups)
        
        self.tableView.reloadData()
    }


}

extension HGGroupController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groups[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.indexArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ID) as! HGGroupCell
        let model = self.groups[indexPath.section][indexPath.row]
        cell.groupIcon.sd_setImageWithURL(NSURL(string: model.groupportraituri)!)
        cell.groupName.text = model.groupname
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.indexArray[section]
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return self.indexArray
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 48
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let model = self.groups[indexPath.section][indexPath.row]
        //进入指定的群聊天界面
        let chatCtrl = HGChatController()
        chatCtrl.conversationType = RCConversationType.ConversationType_GROUP
        chatCtrl.targetId = model.groupid
        chatCtrl.title = model.groupname
        HGUtils.setString("init", key: HGFlags.ud_tmp)
        self.navigationController!.pushViewController(chatCtrl, animated: true)
    }
    
}

extension HGGroupController {
    
    func sortByLetter(groups: [HGGroupModel]) -> (groups: [[HGGroupModel]],letters: [String]) {
        
        if groups.count == 0 {
            
            return (groups: [ ],letters: [])
        }
        
        //取出所有的名称
        
        var items: [String] = []
        for group in groups {
            
            items.append(group.groupname)
        }
        
        let letters = ChineseString.IndexArray(items)
        
        let names = ChineseString.LetterSortArray(items)
        
        var results: [[ HGGroupModel]] = []
        //array 代表每个字母下的名称
        for array in names {
            //name 代表每个名称
            var result: [HGGroupModel] = []
            
            for name in (array as! NSArray) {
                
                //找到对应名称的团
                for each in groups {
                    
                    if (name as! String) == each.groupname {
                        
                        result.append(each)
                        break
                    }
                    
                }
            }
            
            results.append(result)
        }
        

        //处理
        return (groups: results,letters: (letters as NSArray) as! [String])
    }
}
