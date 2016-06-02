//
//  HGChatController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/17/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import STPopup
import Alamofire
import SwiftyJSON
import Toast


class HGChatController: RCConversationViewController,RCMessageCellDelegate {
    
    var smilePage = 0
    var smileWhich = 0
    var videoPage = 0
    var videoWhich = 0
    
    var liveEnter: UIButton?

    var isLive = false
    
    var smiles: [String] = []
    var videos: [HGVideoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let liveEnter = UIButton(frame: CGRectMake(HGFlags.kScreenWidth - 140,92,100,36))
        liveEnter.setTitle("进入直播", forState: .Normal)
        liveEnter.backgroundColor = UIColor.orangeColor()
        liveEnter.layer.cornerRadius = 10
        liveEnter.setTitleColor(UIColor.redColor(), forState: .Normal)
        liveEnter.addTarget(self, action: #selector(HGChatController.enterLiveRoom), forControlEvents: .TouchUpInside)
        self.view.addSubview(liveEnter)
        self.liveEnter = liveEnter
        //self.liveEnter!.hidden = true
        
        let query = UIButton(frame: CGRectMake(0,4,56,36))
        query.setTitle("查看群", forState: .Normal)
        query.setTitleColor(UIColor.blueColor(), forState: .Normal)
        query.addTarget(self, action: #selector(HGChatController.queryGroupInfo), forControlEvents: .TouchUpInside)
        let barItem = UIBarButtonItem(customView: query)
        self.navigationItem.rightBarButtonItem = barItem
        
        self.registerClass(HGVideoMessageCell.self, forCellWithReuseIdentifier: HGViedoMessageTypeIdentifier)
        
        self.pluginBoardView.insertItemWithImage(UIImage(named: "smile_plugin"), title: "笑段子", tag: 101)
        self.pluginBoardView.insertItemWithImage(UIImage(named: "video_plugin"), title: "短视频", tag: 102)
        self.pluginBoardView.insertItemWithImage(UIImage(named: "video_plugin"), title: "直播", tag: 103)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RCIM.sharedRCIM().receiveMessageDelegate = self
        self.setMessageAvatarStyle(.USER_AVATAR_CYCLE)
        if HGUtils.valueFromKey(HGFlags.ud_tmp) == "finish" {
            //直播结束
            print("viewWillAppear finish")
            let extra = "finish"
            let message = RCTextMessage(content: "我结束了直播")
            message.extra = extra
            RCIM.sharedRCIM().sendMessage(.ConversationType_GROUP, targetId: self.targetId, content: message, pushContent: "", pushData: "", success: { (judge) in
                
                print(judge)
                //消息发送成功开始直播
                
                }, error: { (code, judge) in
                    
                    print(code)
            })
        } else {
            
            print("viewWillAppear init")
        }
    }
    
    func queryGroupInfo() -> Void {
        
        let introController = HGGroupIntroController()
        introController.model = HGDataBaseManager.shareInstance().getGroupByGroupId(self.targetId)
        self.navigationController!.pushViewController(introController, animated: true)
    }
    func enterLiveRoom() {
                    
            //进入直播间
            let playVC = HGUtils.viewControllerWithIdentifier("live_play", storyboardName: "Single") as! PlayViewController
            playVC.playURL = "\(HGFlags.live_url_try)\(self.targetId)"
            self.presentViewController(playVC, animated: true, completion: nil)

        
    }
    

    override func pluginBoardView(pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        
        switch Int32(tag) {
        case PLUGIN_BOARD_ITEM_ALBUM_TAG:
            
            super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
        case PLUGIN_BOARD_ITEM_CAMERA_TAG:
            
            super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
        case PLUGIN_BOARD_ITEM_LOCATION_TAG:
            
            super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
        case 101:

            //处理笑段子的发送
            self.handleSmile()
        case 102:
            
            //处理搞笑视频的发送
            self.handleVideo()

        case 103:
            
            //处理直播
            self.enterLiveVideo()
        default:
            
            break
        }
    }

}

extension HGChatController: RCIMReceiveMessageDelegate{
    
    override func didTapCellPortrait(userId: String!) {
        
        print("click the icon \(userId)")
    }
    
    func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        
        
        let value = message.content as? RCTextMessage
        
        if let value = value {
            
            if let extra = value.extra {
                
                if extra.hasPrefix("rtmp") {
                    print("live begin")
                    self.isLive = true
                    //通知有人直播
                    self.liveEnter!.hidden = false
                    
                } else if extra == "finish" {
                    //通知直播结束
                    self.isLive = false
                    self.liveEnter!.hidden = true
                    print("live end")
                }
                
            }
            
            
        }
        
    }
    
    override func rcConversationCollectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> RCMessageBaseCell! {

        let model = self.conversationDataRepository.objectAtIndex(indexPath.row) as! RCMessageModel
        let messageContent = model.content!
        
        
        if messageContent.isMemberOfClass(HGVideoMessage.self) {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HGViedoMessageTypeIdentifier, forIndexPath: indexPath) as! HGVideoMessageCell
            cell.setDataModel(model)
            cell.delegate = self
            return cell
        }
        
        return super.rcConversationCollectionView(collectionView, cellForItemAtIndexPath: indexPath)
    }
    
    override func didTapMessageCell(model: RCMessageModel!) {
        
        super.didTapMessageCell(model)
        
        if model.objectName == "HG: VDMsg" {
            
            let videoController = HGVideoController()
            videoController.videoURL = (model.content as! HGVideoMessage).videoURL
            let popup = STPopupController(rootViewController: videoController)
            
            popup.presentInViewController(self)
        }
    }
    
    override func rcConversationCollectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        let model = self.conversationDataRepository.objectAtIndex(indexPath.row) as! RCMessageModel
        let messageContent = model.content!
        
        
        if messageContent.isMemberOfClass(HGVideoMessage.self) {
            
            return CGSizeMake(collectionView.frame.width, 140)
        }
        
        return super.rcConversationCollectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: indexPath)
    }

}

extension HGChatController: HGSmileCellDelegate {
    
    func sendClickWithButton(next: UIButton) {
        let text = HGSmileCell.shareInstance.infoView.text
        
        if let _ = text {
            
        } else {
            
            return
        }
        
        let message = RCTextMessage(content: text!)
        RCIM.sharedRCIM().sendMessage(.ConversationType_GROUP, targetId: self.targetId, content: message, pushContent: "", pushData: "", success: { (judge) in
            
            print(judge)
            
            }, error: { (code, judge) in
                
            print(code)
        })
    }
    
    //实现文本笑话的代理处理
    func previousClickWithButton(previous: UIButton) {
        
        //到临界时
        if self.smilePage == 0 && self.smileWhich == 0 {
            
            print("minimum")
            return
        }
        
        if self.smileWhich == 0 {
            
            //再请求一下，即换到另一个页面
            self.smilePage -= 1
            self.smileWhich = 19
             HGSmileCell.shareInstance.dictor.startAnimating()
            self.fetchSmilesByPage(self.smilePage + 1)
        }
        
        self.smileWhich -= 1
        
        HGSmileCell.shareInstance.content = self.smiles[self.smileWhich]
    }
    
    func nextClickWithButton(next: UIButton) {
        
        if self.smileWhich == 19 {
            
            //再请求一下，即换到另一个页面
            self.smilePage += 1
            self.smileWhich = 0
            HGSmileCell.shareInstance.dictor.startAnimating()
            self.fetchSmilesByPage(self.smilePage + 1)
        }
        
        self.smileWhich += 1
        
        HGSmileCell.shareInstance.content = self.smiles[self.smileWhich]
        
    }
    
}

//处理搞笑视频的代理处理
extension HGChatController: HGVideoCellDelegate {
    
    func nextClickInVideoWithButton(next: UIButton) {
        
        if self.videoWhich == (self.videos.count - 1) {
            
            //再请求一下，即换到另一个页面
            self.videoPage += 1
            self.videoWhich = 0
            HGVideoCell.shareInstance.dictor.startAnimating()
            self.fetchVideosByPage(self.videoPage)
        }
        
        self.videoWhich += 1
        
        HGVideoCell.shareInstance.content = self.videos[self.videoWhich].content
        HGVideoCell.shareInstance.imageURL = self.videos[self.videoWhich].iconURL
        
    }
    
    func previousClickInVideoWithButton(previous: UIButton) {
        
        //到临界时
        if self.videoPage == 0 && self.videoWhich == 0 {
            
            print("minimum")
            return
        }
        
        if self.videoWhich == 0 {
            
            //再请求一下，即换到另一个页面
            self.videoPage -= 1
            self.videoWhich = self.videos.count - 1
            HGVideoCell.shareInstance.dictor.startAnimating()
            self.fetchVideosByPage(self.videoPage + 1)
        }
        
        self.videoWhich -= 1
        
        HGVideoCell.shareInstance.content = self.videos[self.videoWhich].content
        HGVideoCell.shareInstance.imageURL = self.videos[self.videoWhich].iconURL
        
    }
    
    func sendClickInVideoWithButton(next: UIButton) {
        
        let text = HGVideoMessage(imageURL: self.videos[self.videoWhich].iconURL, videoURL: self.videos[self.videoWhich].videoURL)
        RCIM.sharedRCIM().sendMessage(.ConversationType_GROUP, targetId: self.targetId, content: text, pushContent: "", pushData: "", success: { (judge) in
            
            print(judge)
            
            }, error: { (code, judge) in
                
                print(code)
        })

    }
}


//处理文本笑话
extension HGChatController {
    
    func handleSmile() {
        
        HGSmileCell.shareInstance.showInView(self.view)
        HGSmileCell.shareInstance.delegate = self
        if self.smiles.count > 0 {
            
            HGSmileCell.shareInstance.content = self.smiles[self.smileWhich]
        } else {
            
            HGSmileCell.shareInstance.dictor.startAnimating()
            fetchSmilesByPage(self.smilePage)
            //重新获取数据
        }
        
        
    }
    
    func fetchSmilesByPage(page: Int) {
        
        Alamofire.request(.GET, HGFlags.smile_url, parameters: ["key": HGFlags.APPStore_Key,"page": self.smilePage + 1], encoding: .URL, headers: [:]).validate().responseJSON { response  in
            
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let status = json["error_code"].int!
                    
                    switch status {
                        
                    //成功获取数据
                    case 0:
                        let lists = json["result"].array!
                        
                        var result: [String] = []
                        for list in lists {
                            
                            let smile = list["content"].string!
                            result.append(smile)
                        }
                        
                        self.smiles = result
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            HGSmileCell.shareInstance.dictor.stopAnimating()
                            HGSmileCell.shareInstance.content = self.smiles[self.smileWhich]
                        })
                    //没有获取数据，默认不处理
                    default:
                        print("nothing to fetch")
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


//处理搞笑视频
extension HGChatController {
    
    func handleVideo() {
        
        HGVideoCell.shareInstance.showInView(self.view)
        HGVideoCell.shareInstance.delegate = self
        if self.videos.count > 0 {
            
            HGVideoCell.shareInstance.content = self.videos[self.videoWhich].content
            HGVideoCell.shareInstance.imageURL = self.videos[self.videoWhich].iconURL
        } else {
            
            print("fetchVideosByPage")
            HGVideoCell.shareInstance.dictor.startAnimating()
            fetchVideosByPage(self.videoPage)
            //重新获取数据
        }
        
        
    }
    
    func fetchVideosByPage(page: Int) {
        
        let url = videoPage == 0 ? "\(HGFlags.video_url).html" : "\(HGFlags.video_url)_\(page + 1).html"
        
        Alamofire.request(.GET, url).response { request, response, data, error in
            if let data = data {
                
                let cfEnc = CFStringEncodings.GB_18030_2000
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                let dogString:String = NSString(data: data, encoding: enc)! as String
                let datas = HGUtils.parseVideo(dogString)
                if datas.count > 0 {
                    
                    self.videos = HGUtils.parseVideo(dogString)
                    print(self.videos)
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        HGVideoCell.shareInstance.dictor.stopAnimating()
                        HGVideoCell.shareInstance.content = self.videos[self.videoWhich].content
                        HGVideoCell.shareInstance.imageURL = self.videos[self.videoWhich].iconURL
                    })
                } else {
                    
                    print("no data")
                }
                
            } else {
                
                print("net error")
            }
        }
        
    }
    
    
}

extension HGChatController {
    
    func enterLiveVideo() {
        
        if self.isLive {
            
            let style = CSToastStyle(defaultStyle: ())
            style.messageColor = UIColor.redColor()
            self.view.makeToast("该团已有人在直播", duration: 2.0, position: CSToastPositionCenter, style: style)
            return
        }
        
        let extra = "\(HGFlags.live_url_try)\(self.targetId)"
        let message = RCTextMessage(content: "我发起了直播")
        message.extra = extra
        RCIM.sharedRCIM().sendMessage(.ConversationType_GROUP, targetId: self.targetId, content: message, pushContent: "", pushData: "", success: { (judge) in
            
            print(judge)
            
            //消息发送成功开始直播
            let publishVC = HGUtils.viewControllerWithIdentifier("live_publish", storyboardName: "Single") as! PublishViewController
            publishVC.publishURL = "\(HGFlags.live_url_try)\(self.targetId)"
        
            self.presentViewController(publishVC, animated: true, completion: nil)
            
            
            }, error: { (code, judge) in
                
                print(code)
        })
    }
}
