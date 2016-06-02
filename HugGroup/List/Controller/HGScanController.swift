//
//  HGScanController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/23/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import AVFoundation

class HGScanController: UIViewController {

    var session: AVCaptureSession!
    
    var preview: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫一扫"
        self.view.backgroundColor = UIColor.whiteColor()
        self.scanQCode()
    }
    
    func scanQCode() {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input = try? AVCaptureDeviceInput(device: device)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        let session = AVCaptureSession()
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        self.session = session
        let preview = AVCaptureVideoPreviewLayer(session: self.session)
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        preview.frame = CGRectMake(20, 96, HGFlags.kScreenWidth - 40, HGFlags.kScreenWidth - 40)
        self.view.layer.insertSublayer(preview, atIndex: 100)
        self.preview = preview
        self.session.startRunning()
    }
    
}

extension HGScanController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        self.session.stopRunning()
        if metadataObjects.count > 0 {
            
            let obj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            let url = obj.stringValue
            
            if url.hasPrefix("HugGroup://") || url.hasPrefix("http") {
                
               UIApplication.sharedApplication().openURL(NSURL(string: obj.stringValue)!)
            }
            
        }
    }
    
    
}

