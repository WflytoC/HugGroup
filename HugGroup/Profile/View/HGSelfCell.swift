//
//  HGSelfCell.swift
//  HugGroup
//
//  Created by wcshinestar on 4/12/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGSelfCell: UITableViewCell {

    //Mark：IBOutlet
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    
    @IBOutlet weak var sexView: UILabel!
    
    @IBOutlet weak var areaView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconView.backgroundColor = UIColor.yellowColor()
        self.iconView.layer.cornerRadius = 26.5
        self.iconView.clipsToBounds = true
        print("awakeFromNib-profile")
    }

    
}
