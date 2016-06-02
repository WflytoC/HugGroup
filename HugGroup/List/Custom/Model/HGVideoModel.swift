//
//  HGVideoModel.swift
//  HugGroup
//
//  Created by wcshinestar on 4/22/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGVideoModel: NSObject {

    var videoURL: String = ""
    var iconURL: String = ""
    var content: String = ""
    
    init(video: String,icon: String,content: String) {
        
        self.videoURL = video
        self.iconURL = icon
        self.content = content
        
    }
    
}
