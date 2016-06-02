//
//  HGIntroCell.swift
//  HugGroup
//
//  Created by wcshinestar on 4/21/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGIntroCell: UITableViewCell {

    @IBOutlet weak var infoView: UILabel!
    
    
    @IBOutlet weak var explainView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.explainView.hidden = true
    }


    
}
