//
//  HGCodeController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/23/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGCodeController: UIViewController {
    
    var groupID: String?
    var codeImage: UIImage?

    @IBOutlet weak var codeView: UIImageView!

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "团的二维码"
        self.createQCode("HugGroup://ccmobile.com?\(self.groupID!)")
    }
    
    func createQCode(info: String) {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setDefaults()
        let data = info.dataUsingEncoding(NSUTF8StringEncoding)!
        filter.setValue(data, forKey: "inputMessage")
        let outputImage = filter.outputImage!
        let image = UIImage(CIImage: outputImage, scale: 1.0, orientation: UIImageOrientation(rawValue: 1)!)
        self.codeImage = image
        self.codeView.image = self.codeImage!
    }

}
