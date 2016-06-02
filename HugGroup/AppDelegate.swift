//
//  AppDelegate.swift
//  HugGroup
//
//  Created by wcshinestar on 4/10/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let session = AVAudioSession.sharedInstance()
        do {
            
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: [.DefaultToSpeaker])
        try session.setActive(true)
        } catch let error {
            print(error)
        }
        
        
        SMSSDK.registerApp(HGFlags.sd_appKey, withSecret: HGFlags.sd_appSecret)
        HGUtils.registerShareSDK()
        RCIM.sharedRCIM().initWithAppKey(HGFlags.rc_appKey)
        RCIM.sharedRCIM().registerMessageType(HGVideoMessage.self)
        RCIM.sharedRCIM().userInfoDataSource = self
        RCIM.sharedRCIM().groupInfoDataSource = self
        
        if let _ = HGUtils.valueFromKey(HGFlags.ud_isLogin) {
            
            HGUtils.buildLinkWithRC()
        } else {
            startLoginAndRegister()
            
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        print("new url = \(url)")
        let host = url.host
        let query = url.query
        print("url = \(url.absoluteString)")
        //类似于这样：HugGroup://ccmobile.com?groupid
        if let host = host,query = query where host == "ccmobile.com"{
            
            print("verify successfully")
            
            let status = HGUtils.valueFromKey(HGFlags.ud_isLogin)
            
            if let _ = status {
                
                let schema = HGUtils.viewControllerWithIdentifier("schema_view", storyboardName: "Single") as! HGShareController
                schema.groupID = query
                self.window!.rootViewController!.addChildViewController(schema)
                self.window!.addSubview(schema.view)
                
            }
            
        }
        
        return true
    }
    
    
    //Mark: 登录与注册
    
    func startLoginAndRegister() -> Void {
        
        let rootViewController = HGUtils.viewControllerWithIdentifier("start_nav", storyboardName: "Start") as! UINavigationController
        self.window!.rootViewController = rootViewController
        
    }
    
    func startMainStoryboard() {
        
        let rootViewController = HGUtils.viewControllerWithIdentifier("main_tab", storyboardName: "Main") as! UITabBarController
        self.window!.rootViewController = rootViewController
    }


}

extension AppDelegate: RCIMUserInfoDataSource,RCIMGroupInfoDataSource{
    
    func getGroupInfoWithGroupId(groupId: String!, completion: ((RCGroup!) -> Void)!) {
        
        HGUtils.getRCGroupByID(groupId,completion: completion)
    }
    
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        
        HGUtils.getRCUserInfoByID(userId, completion: completion)
    }
}
















