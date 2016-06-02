//
//  HGShareModule.swift
//  HugGroup
//
//  Created by wcshinestar on 4/23/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SCLAlertView

class HGShareModule: NSObject {

    
    static let Names = ["QQ好友","微信好友","微信朋友圈","短信","邮件"]
    static let Ways = [SSDKPlatformType.SubTypeQQFriend,SSDKPlatformType.SubTypeWechatSession,SSDKPlatformType.SubTypeWechatTimeline,SSDKPlatformType.TypeSMS,SSDKPlatformType.TypeMail]
    
    static func recommendApp(link: String,image: UIImage?,way: Int) {
        
        
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        let codeImage = (image == nil) ? UIImage(named: "icon_home.png") : image
        
        
        shareParames.SSDKSetupShareParamsByText("真诚地邀您加入该团",
                                                images : codeImage,
                                                url : NSURL(string:link),
                                                title : "点击进入该团",
                                                type : SSDKContentType.App)
        
        //2.进行分享
        ShareSDK.share(HGShareModule.Ways[way], parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            switch state{
                
            case SSDKResponseState.Success:
                SCLAlertView().showTitle("分享成功", subTitle: "感谢您的分享", style: .Success)
                break
            case SSDKResponseState.Fail:
                SCLAlertView().showTitle("分享失败", subTitle: "可能您没有安装客户端，换种方式分享吧", style: .Error)
                break
            case SSDKResponseState.Cancel:
                SCLAlertView().showTitle("分享失败", subTitle: "您取消了分享，再去分享一次", style: .Error)
                break
            default:
                break
            }
        }
    }
    
    static func shareGroup(link: String,image: UIImage?) {
            
            let alertView = SCLAlertView()
            for i in 0...4 {
                alertView.addButton(HGShareModule.Names[i]) {
                    
                    HGShareModule.recommendApp(link,image: image, way: i)
                }
            }
            
            alertView.addButton("取 消") {[unowned alertView] () -> Void in
                alertView.hideView()
            }
            alertView.showCloseButton = false
            alertView.showSuccess("邀请其他人加入该团",subTitle: "")
        } 
    }
