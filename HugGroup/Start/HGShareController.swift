//
//  HGShareController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/22/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD
import Toast

class HGShareController: UIViewController {

    var groupID: String?
    var groupCall: String?
    var group: HGGroupModel?
    
    @IBOutlet weak var groupIconView: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
    
    
    @IBOutlet weak var groupClass: UILabel!
    
    @IBOutlet weak var groupTime: UILabel!
    
    
    @IBOutlet weak var groupInfo: UILabel!
    
    
    @IBAction func joinAction(sender: AnyObject) {
        
        self.addGroup()
    }
    
    @IBOutlet weak var joinBtn: UIButton!
    
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.view.removeFromSuperview()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.joinBtn.layer.cornerRadius = 10
        self.cancelBtn.layer.cornerRadius = 10
        self.groupIconView.layer.cornerRadius = 36
        self.groupIconView.clipsToBounds = true
        SVProgressHUD.showWithStatus("加载群信息.......")
        self.fetchGroupInfoByID(self.groupID!)
        
        
        
    }


}

extension HGShareController {
    
    func fetchGroupInfoByID(groupID: String) {
        
        Alamofire.request(.POST, HGFlags.IM_searchGroup, parameters: ["groupid": self.groupID!], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    print("HGShareController join =\(json.description)")
                    let status = json["status"].int!
                    
                    switch status {
                        
                    //成功获取数据
                    case 1:
                        
                        let dict = json.dictionaryObject!
                        self.group = HGGroupModel.groupWithDict(dict)
                        let icon = json["groupportraituri"].string!
                        let name = json["groupname"].string!
                        self.groupCall = name
                        let info = json["groupinfo"].string!
                        let time = json["time"].string!
                        let first = time.componentsSeparatedByString(" ").first!
                        let groupClass = json["groupclass"].string!
                        let type = json["grouptype"].string!
                        let kind = type == "1" ? "私有团：\(groupClass)" : "公有团：\(groupClass)"
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.groupIconView.sd_setImageWithURL(NSURL(string: icon))
                            self.groupName.text = name
                            self.groupClass.text = kind
                            self.groupInfo.text = info
                            self.groupTime.text = "创建时间是：\(first)"
                        })
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
    
    
    func addGroup() {
        
        let group = HGDataBaseManager.shareInstance().getGroupByGroupId(self.groupID!)
        if let _ = group {
            
            self.view.makeToast("您已经是该团成员")
            return
        }
        
        if self.groupCall == nil {
            
            self.view.makeToast("群信息还未加载完毕")
            return
        }
        
        SVProgressHUD.showWithStatus("加群中....")
        //申请加入团
        Alamofire.request(.POST, HGFlags.IM_addGroup, parameters: ["groupid": self.groupID!,"groupname": self.groupCall!,"userid": HGUtils.valueFromKey(HGFlags.ud_phone)!], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let status = json["status"].int!
                    
                    switch status {
                        
                    //成功获取数据
                    case 1:
                        
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            HGUtils.logGroupCount()
                            
                            HGDataBaseManager.shareInstance().insertGroupToDB(self.group!)
                            
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
