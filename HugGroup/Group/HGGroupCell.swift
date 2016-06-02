//
//  HGGroupCell.swift
//  HugGroup
//
//  Created by wcshinestar on 4/20/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGGroupCell: UITableViewCell {

    
    @IBOutlet weak var groupIcon: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.groupIcon.layer.cornerRadius = 20
    }

    
}
