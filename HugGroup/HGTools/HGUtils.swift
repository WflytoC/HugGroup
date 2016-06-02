//
//  HGUtils.swift
//  HugGroup
//
//  Created by wcshinestar on 4/11/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kanna

class HGUtils: NSObject {
    
    //存储用户数据到本地
    static func storeUserData(json: JSON) {
        
        //手机号码单独存储
        let location = json["location"].string!
        let token = json["token"].string!
        let sex = json["sex"].string!
        let name = json["name"].string!
        let portraitUri = json["portraitUri"].string!
        
        HGUtils.setString(location, key: HGFlags.ud_location)
        HGUtils.setString(token, key: HGFlags.ud_token)
        HGUtils.setString(sex, key: HGFlags.ud_sex)
        HGUtils.setString(name, key: HGFlags.ud_nickName)
        HGUtils.setString(portraitUri, key: HGFlags.ud_portraitUri)
        
    }
    
    //删除用户的本地数据
    
    static func dropUserData() -> Void {
        
        HGUtils.dropForKey(HGFlags.ud_location)
        HGUtils.dropForKey(HGFlags.ud_token)
        HGUtils.dropForKey(HGFlags.ud_sex)
        HGUtils.dropForKey(HGFlags.ud_nickName)
        HGUtils.dropForKey(HGFlags.ud_portraitUri)
        
    }
    
    //Mark：利用NSUserDefaults将本地数据取出来
    
    static func valueFromKey(key: String) -> String? {
        
        let UD = NSUserDefaults.standardUserDefaults()
        let value = UD.stringForKey(key)
        return value
    }
    
    //Mark：删除指定key的本地数据存储
    
    static func dropForKey(key: String) -> Void {
        
        let UD = NSUserDefaults.standardUserDefaults()
        UD.removeObjectForKey(key)
    }
    
    //Mark：利用NSUserDefaults将数据存储在本地
    
    static func setString(string: String,key: String) {
        
        let UD = NSUserDefaults.standardUserDefaults()
        UD.setObject(string, forKey: key)
    }
    
    
    
    //Mark： 根据identifier从storyboard中获取viewController
    static func viewControllerWithIdentifier(identifier: String ,storyboardName: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboardName,bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier)
        return viewController
    }
    
    //Mark：进入主页面
    
    static func enterMainPage() {
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            
            HGUtils.downloadIcon()
            appDelegate.startMainStoryboard()
        }
        
    }
    
    
    //Mark：进入登录页面
    
    static func enterLoginPage() {
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            
            
            appDelegate.startLoginAndRegister()
        }
        
    }
    
    
    static func getCities() -> (provinces: [String],cities: [String: [String]]) {
        
        let data = NSData(contentsOfFile: HGUtils.getFilePathInBundle("cities", type: "json"))!
        let json = JSON(data: data)
        
        var pros: [String] = []
        var cits: [String: [String]] = [:]
        
        let provinces = json["城市代码"].array
        for province in provinces! {
            
            let pro = province["省"].string!
            pros.append(pro)
            let arr = province["市"].array!
            var items: [String] = []
            for item in arr {
                
                let single = item["市名"].string!
                items.append(single)
            }
            
            cits[pro] = items
        }
        
        return (provinces: pros,cities: cits)
        
    }
    
    //获取bundle中的文件路径
    static func getFilePathInBundle(fileName: String,type: String) -> String {
        let bundlePath = NSBundle.mainBundle().resourcePath!.stringByAppendingString("/HugGroup.bundle")
        let bundle = NSBundle(path: bundlePath)
        return bundle!.pathForResource(fileName, ofType: type)!
        
    }
    
    //获取应用沙盒路径
    static func createFilePath(fileName: String) -> String{
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/\(fileName)")
        return path
    }
    
    
    //建立与融云服务器的连接
    
    static func buildLinkWithRC() -> Void {
        
        print(HGUtils.valueFromKey(HGFlags.ud_token))
        RCIM.sharedRCIM().connectWithToken(HGUtils.valueFromKey(HGFlags.ud_token)!, success: { userID in
            //连接成功
            print("连接到融云服务器")
            
            }, error: { status in
                //连接失败
                print("status = \(status.rawValue)")
            }) { 
                //出现错误
                print("token")
        }
    }
    
    //下载用户头像，并保存于本地
    
    static func downloadIcon() -> Void {
        
        let fileName = NSURL(fileURLWithPath: HGUtils.valueFromKey(HGFlags.ud_portraitUri)!).lastPathComponent!
        let fileManager = NSFileManager.defaultManager()
        let path = HGUtils.createFilePath("\(fileName)")
                
        if fileManager.fileExistsAtPath(path) {
            
            try! fileManager.removeItemAtPath(path)
        }
        
        
        Alamofire.download(.GET, HGUtils.valueFromKey(HGFlags.ud_portraitUri)!) { (_, _) -> NSURL in
            
            
            return NSURL(fileURLWithPath: path)
        }
        
    }
    
    //Mark:获取时间戳
    
    static func obtainTimestamp() -> String {
        
        let date = NSDate.init(timeIntervalSinceNow: 0)
        let sec = Int(date.timeIntervalSince1970 * 1000)
        
        return "\(sec)"
    }
    
    //返回RCGroup
    
    static func getRCGroupByID(groupID: String,completion: ((RCGroup!) -> Void)!) -> Void {
        
        var group = HGDataBaseManager.shareInstance().getGroupByGroupId(groupID)
        
        if let group = group {
            
            print("From Database")
            let result = RCGroup(groupId: group.groupid, groupName: group.groupname, portraitUri: group.groupportraituri)
            dispatch_async(dispatch_get_main_queue(), {
                completion(result)
            })
            
            return
        }
        
        print("From network")
        Alamofire.request(.POST,HGFlags.IM_searchGroup, parameters: ["groupid": groupID], encoding: .URL, headers: nil).validate().responseJSON { response in
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let dict = json.dictionaryObject
                    let status = json["status"].int!
                    switch status {
                        

                    case 1 ://成功获取组的信息
                        
                        group = HGGroupModel.groupWithDict(dict)
                        
                        HGDataBaseManager.shareInstance().insertGroupToDB(group)
                        
                        let result = RCGroup(groupId: groupID, groupName: json["groupname"].string!, portraitUri: json["groupportraituri"].string!)
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(result)
                        })
                    default:
                        
                        let group = RCGroup(groupId: groupID, groupName: "\(groupID)", portraitUri: "")
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(group)
                        })
                    }
                    
                }
                
            case .Failure:
                
                let group = RCGroup(groupId: groupID, groupName: "\(groupID)", portraitUri: "")
                dispatch_async(dispatch_get_main_queue(), {
                    completion(group)
                })
            }
            
        }
        
        
    }
    
    //返回RCUserInfo
    
    static func getRCUserInfoByID(userID: String,completion: ((RCUserInfo!) -> Void)!) ->Void {
        
        var person = HGDataBaseManager.shareInstance().getUserByUserId(userID)
        
        if let person = person {
            
            print("From Database")
            let result = RCUserInfo(userId: person.userid, name: person.name, portrait: person.portraitUri)
            dispatch_async(dispatch_get_main_queue(), {
                completion(result)
            })
            
            return
        }
        
        Alamofire.request(.POST, HGFlags.IM_searchUser, parameters: ["userid": userID], encoding: .URL, headers: nil).validate().responseJSON { response in
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    
                    let json = JSON(value)
                    let dict = json.dictionaryObject
                    let status = json["status"].int!
                    switch status {
                        
                        
                    case 1 ://成功获取组的信息
                        
                        person = HGPersonModel.personWithDict(dict)
                        
                        HGDataBaseManager.shareInstance().insertUserToDB(person)
                        let user = RCUserInfo(userId: userID, name: json["name"].string!, portrait: json["portraitUri"].string!)
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(user)
                        })
                    default:
                        
                        let user = RCUserInfo(userId: userID, name: "", portrait: "")
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(user)
                        })
                    }
                    
                }
                
            case .Failure:
                
                let user = RCUserInfo(userId: userID, name: "", portrait: "")
                dispatch_async(dispatch_get_main_queue(), {
                    completion(user)
                })
            }
            
        }
    }
    
    //解析视频短片
    static func parseVideo(html: String) -> [HGVideoModel] {
        
        var models: [HGVideoModel] = []
        
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            
            for li in doc.xpath("//li[@style='height:154px']") {
                for item in li.xpath("./a") {
                    let title = item["title"]!
                    let video = "http://www.7791.com.cn" + item["href"]!
                    let icon = item.xpath("./img")[0]["src"]!
                    let model = HGVideoModel(video: video, icon: icon, content: title)
                    models.append(model)
                }
            }
        }
        return models
    }
    
    //解析网页，获取视频播放地址
    
    static func parseDetail(html: String) -> String {
        
        var result = ""
        
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            for li in doc.xpath("//script") {
                let str = li.text!
                
                if str.containsString("oldswf") {
                    
                    let b = str.rangeOfString("src=")
                    let e = str.rangeOfString("h=480")
                    let si = b!.endIndex
                    let fi = e!.endIndex
                    let range = si...fi
                    result = str.substringWithRange(range)
                    result.removeAtIndex(result.endIndex.predecessor())
                    return result
                }
                
            }
        }
        return result
    }
    
    
    static func registerShareSDK() -> Void {
        
        ShareSDK.registerApp(HGFlags.SDK_APPKEY,
                             //分享的平台：QQ好友、QQ空间、微信好友、微信朋友圈、短信、邮箱
            activePlatforms: [
                SSDKPlatformType.SubTypeQQFriend.rawValue,
                SSDKPlatformType.SubTypeQZone.rawValue,
                SSDKPlatformType.SubTypeWechatSession.rawValue,
                SSDKPlatformType.SubTypeWechatTimeline.rawValue,
                SSDKPlatformType.TypeSMS.rawValue,
                SSDKPlatformType.TypeMail.rawValue],
            onImport: {(platform : SSDKPlatformType) -> Void in
                
                switch platform{
                    
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform {
                    
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId(HGFlags.WeChat_APPID, appSecret: HGFlags.WeChat_APPSECRET)
                    break
                case SSDKPlatformType.TypeQQ:
                    //设置QQ应用信息
                    appInfo.SSDKSetupQQByAppId(HGFlags.QQ_APPID, appKey: HGFlags.QQ_APPKEY, authType: SSDKAuthTypeBoth)
                    break
                default:
                    break
                    
                }
        })
    }
 
    
    static func logGroupCount() {
        
        print("groups count = \(HGDataBaseManager.shareInstance().getAllGroups().count)")
    }
}


