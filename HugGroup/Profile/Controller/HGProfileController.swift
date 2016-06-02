//
//  HGProfileController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/12/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SCLAlertView
import Toast

private let customCell = "custom"
private let systemCell = "system"
private let itemTitles = ["商店评分","分享应用","清空缓存","关于我们"]

class HGProfileController: UIViewController{
    
    var tableView: UITableView?
    
    @IBOutlet weak var quitBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.quitBtn.layer.cornerRadius = 10
        self.buildTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView!.reloadData()
    }
    
    func buildTableView() {
        
        self.tableView = UITableView(frame: CGRectMake(0, 64, HGFlags.kScreenWidth, HGFlags.kScreenHeight - 200), style: .Grouped)
        self.view.addSubview(self.tableView!)
        //self.tableView!.scrollEnabled = false
        self.tableView!.separatorStyle = .SingleLine
        self.tableView!.separatorColor = UIColor.blackColor()
        
        self.tableView!.registerNib(UINib.init(nibName: "HGSelfCell", bundle: nil), forCellReuseIdentifier: customCell)
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: systemCell)
        
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark：IBAction
    
    
    @IBAction func quitAction(sender: AnyObject) {
        
        HGUtils.dropForKey(HGFlags.ud_isLogin)
        HGUtils.dropForKey(HGFlags.ud_phone)
        HGUtils.dropUserData()
        HGDataBaseManager.shareInstance().clearGroupsData()
        HGDataBaseManager.shareInstance().clearPersonsData()
        RCIM.sharedRCIM().logout()
        HGUtils.enterLoginPage()

    }
    
    

}

extension HGProfileController: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return [1,2,2][section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(customCell) as! HGSelfCell
            
            (cell as! HGSelfCell).nickName.text = HGUtils.valueFromKey(HGFlags.ud_nickName)
            (cell as! HGSelfCell).sexView.text = HGUtils.valueFromKey(HGFlags.ud_sex)
            (cell as! HGSelfCell).areaView.text = HGUtils.valueFromKey(HGFlags.ud_location)
            
            (cell as! HGSelfCell).iconView.image = UIImage(contentsOfFile: HGUtils.createFilePath("15527113304.jpg"))
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(systemCell)
            
            let index = indexPath.section == 2 ? 2 : 0
            
            cell!.textLabel!.text = itemTitles[index + indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1.6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return  64
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        (indexPath.section,indexPath.row)
        switch (indexPath.section,indexPath.row) {
            
        case (0,0):
            
            let vc = HGUtils.viewControllerWithIdentifier("single_info", storyboardName: "Single")
            self.presentViewController(vc, animated: true, completion: nil)
        case (1,0):
            UIApplication.sharedApplication().openURL(NSURL(string: HGFlags.app_url)!)
            break
            
        case (1,1):
            
            self.shareApp()
            
            break
            
        case (2,0):
            
            //设置Toast样式
            let style = CSToastStyle(defaultStyle: ())
            style.messageColor = UIColor.redColor()
            self.view.makeToast("清除缓存中..", duration: 2.0, position: CSToastPositionCenter, style: style)
            
            break
            
        case (2,1):
            
            //关于我们
            let alertView = SCLAlertView()
            
            alertView.addButton("取 消") {[unowned alertView] () -> Void in
                alertView.hideView()
            }
            alertView.showCloseButton = false
            let info = "抱团团队成员有：\n\n薛钧文(产品经理)\n\n李若飞(美术设计)\n\n任天鑫(Android开发)\n\n帅纯亮(后台开发)\n\n魏闯(iOS开发)"
            alertView.showSuccess("抱团团队",subTitle: info)
            break
            
        default:
            break
        }
    }
    
    
}
extension HGProfileController {
    
    func recommendApp(way: Int) {
        
        
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        let codeImage = UIImage(named: "icon_home.png")
        
        
        shareParames.SSDKSetupShareParamsByText("抱团让你我更接近",
                                                images : codeImage,
                                                url : NSURL(string:HGFlags.app_url),
                                                title : "去下载抱团",
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
    
    func shareApp() {
        
        let alertView = SCLAlertView()
        for i in 0...4 {
            alertView.addButton(HGShareModule.Names[i]) {
                
                self.recommendApp(i)
            }
        }
        
        alertView.addButton("取 消") {[unowned alertView] () -> Void in
            alertView.hideView()
        }
        alertView.showCloseButton = false
        alertView.showSuccess("向别人推荐该应用",subTitle: "")
    }
}
