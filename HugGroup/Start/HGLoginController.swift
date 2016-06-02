//
//  HGLoginController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/10/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import Toast
import Alamofire
import SwiftyJSON
import SVProgressHUD

class HGLoginController: UIViewController {
    
    //Mark: IBOutlet
    
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var pWordField: UITextField!
    
    @IBOutlet weak var flagView: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!

    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flagView.layer.cornerRadius = 60
        self.loginBtn.layer.cornerRadius = 12
        self.registerBtn.layer.cornerRadius = 12
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.phoneField.resignFirstResponder()
        self.pWordField.resignFirstResponder()
    }
    

    
    
    //Mark: IBAction
    
    @IBAction func longAction(sender: AnyObject) {
        
        
        let phone = self.phoneField.text!
        let passWord = self.pWordField.text!
        
        
        if phone == "" || passWord == "" {
            
            //设置Toast样式
            let style = CSToastStyle(defaultStyle: ())
            style.messageColor = UIColor.redColor()
            self.view.makeToast("账号与密码不能为空", duration: 2.0, position: CSToastPositionCenter, style: style)
            return
            
        }
        SVProgressHUD.showWithStatus("登陆中...")
        self.startLogin(phone, password: passWord)
        
    }
    

}


extension HGLoginController {
    
    
    
    func startLogin(phone: String,password: String) -> Void {
        
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        Alamofire.request(.POST, HGFlags.url_userLogin, parameters: ["phone": phone,"password": password], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    
                    let json = JSON(value)
                    let status = json["status"].int!
                    switch status {
                        
                    case -1 :
                        self.view.makeToast("该账号还未注册", duration: 2.0, position: CSToastPositionCenter, style: style)
                        self.phoneField.text = ""
                        self.pWordField.text = ""
                    case 0 :
                        self.view.makeToast("密码错误", duration: 2.0, position: CSToastPositionCenter, style: style)
                        self.pWordField.text = ""
                    case 1 :
                        
                        HGUtils.storeUserData(json)
                        
                        HGUtils.setString("login",key: HGFlags.ud_isLogin)
                        
                        HGUtils.setString(self.phoneField.text!, key: HGFlags.ud_phone)
                        
                        HGUtils.buildLinkWithRC()
                        
                        //登陆成功后，加载资源
                        self.fetchDataOfUser()
                        
                        HGUtils.enterMainPage()
                        
                    default:
                        break
        
                    }
                    
                }
                
            case .Failure(let error):
                
                self.view.makeToast("网络出现问题", duration: 2.0, position: CSToastPositionCenter, style: style)
                print(error)
            }
            
        }
        
        
    }
    
    //用户登陆成功后开始获取其数据
    
    func fetchDataOfUser() {
        
        Alamofire.request(.POST, HGFlags.IM_joinGroups, parameters: ["userid": HGUtils.valueFromKey(HGFlags.ud_phone)!], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                                        
                    let json = JSON(value)
                    let status = json["status"].int!
                    
                    switch status {
                        
                        //成功获取数据
                    case 1:
                        print("groups =\(json)")
                        let groups = json["groups"].array!
                        for item in groups {
                            
                            let group = item.dictionaryObject!
                            let result = HGGroupModel.groupWithDict(group)
                            print("login fetch \(result.groupportraituri)")
                            
                            HGUtils.logGroupCount()
                            HGDataBaseManager.shareInstance().insertGroupToDB(result)
                            
                            HGUtils.logGroupCount()
                        }
                        
                        //没有获取数据，默认不处理
                    default:
                        
                        break
                                                
                    }
                    
                }
                
            case .Failure:
                
                print("failure")
                //什么也不处理
            }
            
        }
        
        
        
        
    }
    
}
