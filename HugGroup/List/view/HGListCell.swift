//
//  HGListCell.swift
//  HugGroup
//
//  Created by wcshinestar on 4/17/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGListCell: UITableViewCell {

    //Mark: IBOutlet
    @IBOutlet weak var itemIcon: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemInfo: UILabel!
    
    @IBOutlet weak var itemDate: UILabel!
    
    @IBOutlet weak var itemUnread: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemIcon.layer.cornerRadius = 18
        self.itemIcon.clipsToBounds = true
        self.itemUnread.layer.cornerRadius = 16
        self.itemUnread.clipsToBounds = true
    }


    
}
