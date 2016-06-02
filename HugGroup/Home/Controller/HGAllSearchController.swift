//
//  HGAllSearchController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/23/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

/*
 groups: [ -
 { -
 groupid: 1460960434746
 groupname: 武汉理工抱团团队
 groupportraituri: http://42.96.204.236/baotuan/portraitUri/15527113304.jpg
 groupinfo: 成员有：魏闯、帅纯亮、李若飞、薛钧文、任天鑫
 groupclass: 数码科技
 grouptype: 1
 creator: 15527113304
 time: 2016-04-18 14:20:34
 }
 ]
 */

import UIKit
import SVProgressHUD
import Alamofire
import Toast
import SwiftyJSON
import SDWebImage

private let ID = "detail_cell"

class HGAllSearchController: UIViewController {
    
    var searchBar: UISearchBar?
    var groups: [HGGroupModel] = []
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar(frame:CGRectMake(0,0,HGFlags.kScreenWidth / 2,44))
        self.searchBar = searchBar
        self.navigationItem.titleView = self.searchBar
        
        let search = UIBarButtonItem(title: "搜索", style: .Plain, target: self, action: #selector(HGAllSearchController.searchByWord(_:)))
        self.navigationItem.rightBarButtonItem = search
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.buildTableView()
    }
    
    func buildTableView() {
        
        let tableView = UITableView(frame:self.view.bounds)
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.tableView?.tableFooterView = UIView()
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        self.tableView!.tableFooterView = UIView()
        self.tableView!.registerNib(UINib.init(nibName: "HGDetailCell", bundle: nil), forCellReuseIdentifier: ID)
    }
    
    func searchByWord(sender: UIBarButtonItem) -> Void {
        
        self.searchBar!.resignFirstResponder()
        let word = searchBar!.text
        guard word != "" else {
            return
        }
        searchKeyWord(word!)
    }
}



extension HGAllSearchController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ID) as! HGDetailCell
        let model = self.groups[indexPath.row]
        cell.groupIcon.sd_setImageWithURL(NSURL(string: model.groupportraituri))
        cell.groupName.text = model.groupname
        cell.groupInfo.text = model.groupinfo
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.groups[indexPath.row]
        let alert = UIAlertController(title: "提示", message: "需要加入该团吗?", preferredStyle: .Alert)
        let act1 = UIAlertAction(title: "确定", style: .Default) { action in
            
            self.joinGroup(model.groupid, group: model, groupName: model.groupname)
            
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

extension HGAllSearchController {
    
    func searchKeyWord(word: String) -> Void {
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        Alamofire.request(.POST, HGFlags.IM_searchGroups, parameters: ["keyword": word], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    
                    let json = JSON(value)
                    print(json.description)
                    let status = json["status"].int!
                    switch status {
                        
                    case 1 :
                        
                        
                        var models: [HGGroupModel] = []
                        let arrs = json["groups"].array!
                        for item in arrs {
                            
                            let model = HGGroupModel.groupWithDict(item.dictionaryObject)
                            models.append(model)
                            
                        }
                        self.groups = models
                        self.tableView!.reloadData()
                        
                    default:
                        self.view.makeToast("没有发现相关团", duration: 2.0, position: CSToastPositionCenter, style: style)
                        
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
