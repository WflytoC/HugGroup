//
//  HGVideoCell.swift
//  HugGroup
//
//  Created by wcshinestar on 4/22/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SDWebImage

private let itemHeight: CGFloat = 120
private let buttonHeight: CGFloat = 30
private let originY: CGFloat = 66

@objc protocol HGVideoCellDelegate: NSObjectProtocol {
    
    func previousClickInVideoWithButton(previous: UIButton)
    
    func nextClickInVideoWithButton(next: UIButton)
    
    func sendClickInVideoWithButton(next: UIButton)
}

class HGVideoCell: UIView {
    
    static let shareInstance = HGVideoCell()
    
    //内容与图片
    var infoView: UILabel!
    var iconView: UIImageView!
    
    //四个处理按钮
    var previous: UIButton!
    var next: UIButton!
    var send: UIButton!
    var close: UIButton!
    
    //加载指示器
    var dictor: UIActivityIndicatorView!
    weak var delegate: HGVideoCellDelegate!
    
    var content: String? {
        
        didSet {
            
            self.infoView.text = content!
        }
        
    }
    
    var imageURL: String? {
        
        didSet {
            
            self.iconView.sd_setImageWithURL(NSURL(string: imageURL!)!)
        }
        
    }
    
    
    private init() {
        
        super.init(frame: CGRectZero)
        
        self.infoView = UILabel(frame: CGRectZero)
        self.infoView.numberOfLines = 0
        self.addSubview(self.infoView)
        
        self.iconView = UIImageView(frame: CGRectZero)
        self.addSubview(self.iconView)
        
        self.dictor = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.infoView.addSubview(self.dictor)
        
        self.previous = UIButton(frame: CGRectZero)
        self.addSubview(self.previous)
        self.previous.setTitle("上一条", forState: .Normal)
        self.previous.addTarget(self, action: #selector(HGSmileCell.clickPrevious(_:)), forControlEvents: .TouchUpInside)
        
        self.next = UIButton(frame: CGRectZero)
        self.addSubview(self.next)
        self.next.setTitle("下一条", forState: .Normal)
        self.next.addTarget(self, action: #selector(HGSmileCell.clickNext(_:)), forControlEvents: .TouchUpInside)
        
        self.send = UIButton(frame: CGRectZero)
        self.addSubview(self.send)
        self.send.setTitle("发 送", forState: .Normal)
        self.send.addTarget(self, action: #selector(HGSmileCell.clickSend(_:)), forControlEvents: .TouchUpInside)
        
        self.close = UIButton(frame: CGRectZero)
        self.addSubview(self.close)
        self.close.setTitle("关 闭", forState: .Normal)
        self.close.addTarget(self, action: #selector(HGSmileCell.disappearSmile), forControlEvents: .TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //supView按照是整个屏幕的view处理
    func showInView(supView: UIView) {
        
        self.backgroundColor = UIColor.grayColor()
        self.frame = CGRectMake(0, 0, HGFlags.kScreenWidth, itemHeight)
        supView.addSubview(self)
        
        
        self.infoView.frame = CGRectMake(0, 0, HGFlags.kScreenWidth / 4 * 3, itemHeight - buttonHeight)
        self.iconView.frame = CGRectMake(HGFlags.kScreenWidth / 4 * 3 , 20 , HGFlags.kScreenWidth / 4 - 10, itemHeight - buttonHeight - 40)
        
        self.dictor.frame = CGRectMake(self.frame.width / 2 - 24, self.infoView.frame.height / 2 - 24, 48, 48)
        
        self.previous.frame = CGRectMake(0, itemHeight - buttonHeight,  HGFlags.kScreenWidth / 4, buttonHeight)
        self.next.frame = CGRectMake(HGFlags.kScreenWidth / 4, itemHeight - buttonHeight,  HGFlags.kScreenWidth / 4, buttonHeight)
        self.close.frame = CGRectMake(HGFlags.kScreenWidth / 4 * 3, itemHeight - buttonHeight,  HGFlags.kScreenWidth / 4, buttonHeight)
        self.send.frame = CGRectMake(HGFlags.kScreenWidth / 4 * 2, itemHeight - buttonHeight,  HGFlags.kScreenWidth / 4, buttonHeight)
        
        UIView.animateWithDuration(0.5) {
            
            self.frame.origin.y = originY
        }
    }
    
    func disappearSmile() {
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.frame.origin.y = 0
        } ) { result in
            
            self.removeFromSuperview()
        }
    }
    
    func clickPrevious(sender: UIButton) {
        
        if ((delegate?.respondsToSelector(#selector(HGVideoCellDelegate.previousClickInVideoWithButton(_:)))) != nil){
            
            delegate?.previousClickInVideoWithButton(sender)
        }
    }
    
    func clickNext(sender: UIButton) {
        
        if ((delegate?.respondsToSelector(#selector(HGVideoCellDelegate.nextClickInVideoWithButton(_:)))) != nil){
            
            delegate?.nextClickInVideoWithButton(sender)
        }
    }
    
    func clickSend(sender: UIButton) {
        
        if ((delegate?.respondsToSelector(#selector(HGVideoCellDelegate.sendClickInVideoWithButton(_:)))) != nil){
            
            delegate?.sendClickInVideoWithButton(sender)
        }
    }
}

