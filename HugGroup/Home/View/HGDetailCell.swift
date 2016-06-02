//
//  HGDetailCell.swift
//  HugGroup
//
//  Created by wcshinestar on 4/19/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGDetailCell: UITableViewCell {

    
    @IBOutlet weak var groupIcon: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var groupInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupIcon.layer.cornerRadius = 30
        
    }


    
}
