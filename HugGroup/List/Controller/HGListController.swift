//
//  HGListController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/15/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import KxMenu

private let ID = "list_cell"

class HGListController: RCConversationListViewController {

    var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setDisplayConversationTypes([RCConversationType.ConversationType_GROUP.rawValue])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.edgesForExtendedLayout = .None
        self.conversationListTableView.tableFooterView = UIView()

        let handle = UIButton(frame: CGRectMake(0,0,44,44))
        handle.setImage(UIImage(named: "add_group"), forState: .Normal)
        handle.addTarget(self, action: #selector(HGListController.handleAction(_:)), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: handle)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setConversationPortraitSize(CGSizeMake(56, 56))
        self.setConversationAvatarStyle(.USER_AVATAR_CYCLE)
        self.updateBadgeValueForTabBarItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //网络状态发生变化时更新
        self.showConnectingStatusOnNavigatorBar = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.showConnectingStatusOnNavigatorBar = false
    }

//Mark: IBAction
    
    
     func handleAction(sender: UIButton) {
        
        let create = KxMenuItem("创建团", image: UIImage(named: "home_icon"), target: self, action: #selector(HGListController.createGroup))
        let scan = KxMenuItem("扫一扫", image: UIImage(named: "search_icon"), target: self, action: #selector(HGListController.scanQCode))
        KxMenu.setTintColor(UIColor.whiteColor())
        KxMenu.showMenuInView(self.view, fromRect: sender.frame, menuItems: [create,scan])
    }
    


}

extension HGListController {
    
    //点击菜单触发事件
    func createGroup() {
        
        let createGroupCtrl = HGUtils.viewControllerWithIdentifier("single_create", storyboardName: "Single")
        self.presentViewController(createGroupCtrl, animated: true, completion: nil)
    }
    
    func scanQCode() {
        
        let scanController = HGScanController()
        self.navigationController!.pushViewController(scanController, animated: true)
    }
    
    
}

//处理即时通讯
extension HGListController {
    
    override func didReceiveMessageNotification(notification: NSNotification!) {
        //收到消息
        
        self.updateBadgeValueForTabBarItem()
        
        dispatch_async(dispatch_get_main_queue()) {
            
            super.didReceiveMessageNotification(notification)
        }
    }
    

    
    override func rcConversationListTableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        return 72
    }
    
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        
        let chatCtrl = HGChatController()
        chatCtrl.conversationType = model.conversationType
        chatCtrl.targetId = model.targetId
        chatCtrl.title = model.conversationTitle
        HGUtils.setString("init", key: HGFlags.ud_tmp)
        self.navigationController!.pushViewController(chatCtrl, animated: true)
    }
    
    //更新TabItem的Badge显示
    func updateBadgeValueForTabBarItem() {
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            
            let count = RCIMClient.sharedRCIMClient().getUnreadCount(self?.displayConversationTypeArray)
            if count > 0 {
                
                self?.tabBarItem.badgeValue = "\(count)"
            } else {
                
                self?.tabBarItem.badgeValue = nil
            }
        }
        
    }
    
}












































































