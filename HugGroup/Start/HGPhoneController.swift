//
//  HGPhoneController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/11/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import Toast

class HGPhoneController: UIViewController {
    
    var phoneNumber = ""

    //Mark: IBOutlet
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var numField: UITextField!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyBtn.layer.cornerRadius = 10
        self.nextBtn.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.phoneField.resignFirstResponder()
        self.numField.resignFirstResponder()
    }
    
    
    //Mark: IBAction
    @IBAction func verifyAction(sender: AnyObject) {
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        if self.phoneField.text == "" {
            
            
            self.view.makeToast("号码不能为空", duration: 2.0, position: CSToastPositionCenter, style: style)
            
            return
        }
        
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: self.phoneField.text!, zone: "86", customIdentifier: nil) { (error) in
            
            if let error = error {
                
                print(error)
                self.view.makeToast("验证码发送失败，请再次发送", duration: 2.0, position: CSToastPositionCenter, style: style)
            } else {
                
                self.phoneNumber = self.phoneField.text!
                self.view.makeToast("验证码发送成功，请输入", duration: 2.0, position: CSToastPositionCenter, style: style)
            }
            
        }
        
        
        
    }
    
    @IBAction func nextAction(sender: AnyObject) {
    
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        if self.numField.text == "" {
            
            
            self.view.makeToast("验证码不能为空", duration: 2.0, position: CSToastPositionCenter, style: style)
            
            return
        } else if self.phoneNumber == "" {
            
            self.view.makeToast("您还没进行发送验证码", duration: 2.0, position: CSToastPositionCenter, style: style)
            
            return
        }

        
        SMSSDK.commitVerificationCode(self.numField.text!, phoneNumber: self.phoneNumber, zone: "86") { (error) in
            
            if let _ = error {
                
                self.view.makeToast("您输入的验证码不正确", duration: 2.0, position: CSToastPositionCenter, style: style)
                
            } else {
                
                print(self.phoneNumber)
                let psController = HGUtils.viewControllerWithIdentifier("start_set", storyboardName: "Start") as! HGPWordController
                psController.phoneNumber = self.phoneNumber
                self.presentViewController(psController, animated: true, completion: nil)
                
            }
            
            self.numField.text = ""
        }
        
    }

}






















