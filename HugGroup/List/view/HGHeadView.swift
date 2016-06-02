//
//  HGHeadView.swift
//  HugGroup
//
//  Created by wcshinestar on 4/21/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import SDWebImage

class HGHeadView: UIView {

    var iconView: UIImageView!
    var infoView: UILabel!
    
    init(frame: CGRect,icon: String,info: String) {
        
        super.init(frame: frame)
        
        self.iconView = UIImageView(frame: CGRectMake(HGFlags.kScreenWidth / 2 - 30, 10, 60, 60))
        self.iconView.sd_setImageWithURL(NSURL(string: icon)!)
        self.addSubview(self.iconView)
        
        self.infoView = UILabel(frame: CGRectMake(10,80,HGFlags.kScreenWidth - 20,60))
        self.infoView.numberOfLines = 0
        self.infoView.text = info
        self.addSubview(self.infoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
