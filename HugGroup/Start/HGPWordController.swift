//
//  HGPWordController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/11/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import Toast
import Alamofire
import SwiftyJSON
import SVProgressHUD

class HGPWordController: UIViewController {
    
    var phoneNumber: String?
    
    //Mark: IBOutlet
    @IBOutlet weak var firstPWord: UITextField!
    
    @IBOutlet weak var secondPWord: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmBtn.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.firstPWord.resignFirstResponder()
        self.secondPWord.resignFirstResponder()
    }


    
    //Mark: IBActon
    
    
    @IBAction func backAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.firstPWord.resignFirstResponder()
        self.secondPWord.resignFirstResponder()
    }
    
    @IBAction func confirmAction(sender: AnyObject) {
        
        self.firstPWord.resignFirstResponder()
        self.secondPWord.resignFirstResponder()
        let phone = self.phoneNumber!
        let confirmPassword = self.firstPWord.text!
        let password = self.secondPWord.text!
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        if confirmPassword == "" || password == "" {
            
            self.view.makeToast("密码不能为空", duration: 2.0, position: CSToastPositionCenter, style: style)
            return
        } else if confirmPassword != password {
            
            self.view.makeToast("两次密码不一致", duration: 2.0, position: CSToastPositionCenter, style: style)
            return
        }
        SVProgressHUD.showWithStatus("注册中....")
        self.startRegister(phone, password: password)
        
        
    }

}

extension HGPWordController {
    
    func startRegister(phone: String,password: String) -> Void {
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        Alamofire.request(.POST, HGFlags.url_userRegister, parameters: ["phone": phone,"password": password], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let status = json["status"].int!
                    switch status {
                        
                    case -1 :
                        self.view.makeToast("该账号已经注册", duration: 2.0, position: CSToastPositionCenter, style: style)
                        self.firstPWord.text = ""
                        self.secondPWord.text = ""
                    case 0 :
                        self.view.makeToast("注册失败", duration: 2.0, position: CSToastPositionCenter, style: style)
                    case 1 :
                        HGUtils.setString("login",key: HGFlags.ud_isLogin)
                        HGUtils.setString(self.phoneNumber!, key: HGFlags.ud_phone)
                        HGUtils.storeUserData(json)
                        HGUtils.buildLinkWithRC()
                        HGUtils.enterMainPage()
                    default:
                        break

                    }
                }
                
            case .Failure:
                
                self.view.makeToast("网络出现错误", duration: 2.0, position: CSToastPositionCenter, style: style)
            }
            
        }
        
        
    }
    
}
