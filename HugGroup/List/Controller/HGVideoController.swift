//
//  HGVideoController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/19/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class HGVideoController: UIViewController {

    var videoURL: String?
    
    var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HGUtils.setString("init", key: HGFlags.ud_tmp)
        self.view.backgroundColor = UIColor.whiteColor()
        self.webView = WKWebView(frame: CGRectMake(0 ,0 , HGFlags.kScreenWidth, HGFlags.kScreenHeight), configuration: WKWebViewConfiguration())
        self.contentSizeInPopup = CGSizeMake(300, 400)
        self.view.addSubview(self.webView!)
        
        if let _ = self.videoURL {
            
            self.pullVideoData()
        } else {
            
            print("url is nil")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension HGVideoController {
    
    func pullVideoData() {
        
        print(self.videoURL!)
        Alamofire.request(.GET, self.videoURL!).response { request, response, data, error in
            
            if let data = data {
                
                let cfEnc = CFStringEncodings.GB_18030_2000
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                let dogString:String = NSString(data: data, encoding: enc)! as String
                let url = HGUtils.parseDetail(dogString)
                print("loading....")
                
                if let exist = NSURL(string: url, relativeToURL: nil) {
                    
                    self.webView!.loadRequest(NSURLRequest(URL: exist, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 10.0))
                } else {
                    
                    print("no")
                }
                
            }
        }
    }
    
}
