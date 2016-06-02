//
//  HGCreateGController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/16/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast
import SVProgressHUD

class HGCreateGController: UIViewController {
    
    var selectedGroup = 0 //选择创建的团的种类
    
    var groupIcon: UIImage?
    //Mark:IBOutlet
    @IBOutlet weak var groupNameField: UITextField!
    
    @IBOutlet weak var groupIconView: UIImageView!
    
    
    @IBOutlet weak var groupInfoView: UITextView!
    
    @IBOutlet weak var groupPickerView: UIPickerView!
    
    
    @IBOutlet weak var privateSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupIconView.layer.cornerRadius = 30
        self.groupIconView.clipsToBounds = true
        
        self.groupPickerView.dataSource = self
        self.groupPickerView.delegate = self

        self.groupIconView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(HGInfoController.tapUploadImage(_:)))
        self.groupIconView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.groupInfoView.resignFirstResponder()
        self.groupNameField.resignFirstResponder()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true
    }
    
//Mark: IBActon
    
    @IBAction func backAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func createAction(sender: AnyObject) {
        
        let groupName = self.groupNameField.text!
        let groupInfo = self.groupInfoView.text!
        let groupClass = HGFlags.groupTypes[self.selectedGroup]
        let groupType = self.privateSwitch.on ? 1 : 2
        
        
        //检查信息是否完整
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        if groupName == "" || groupInfo == "" || groupIcon == nil {
            
            self.view.makeToast("团的信息不能为空", duration: 2.0, position: CSToastPositionCenter, style: style)
            return
        }
        
        SVProgressHUD.showWithStatus("创建团中.....")
        
        //将UIImage转化为NSData
        var imageData: NSData?
        
        if let JPEGdata = UIImageJPEGRepresentation(self.groupIcon!, 0.5) {
            
            imageData = JPEGdata
        } else  if let PNGdata = UIImagePNGRepresentation(self.groupIcon!) {
            
            imageData = PNGdata
        }
        
        
        print("groupclass = \(groupClass),groupinfo=\(groupInfo)")
        
        //团ID
        let groupID = HGUtils.obtainTimestamp()
       
        let info = groupInfo.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let classEncode = groupClass.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let name = groupName.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let headers: [String: String] = ["userid": HGUtils.valueFromKey(HGFlags.ud_phone)!,"groupid": groupID,"groupname": name,"groupinfo": info,"groupclass": classEncode,"grouptype": "\(groupType)"]
        
        
        //
        
        //
        
        Alamofire.upload(.POST, HGFlags.IM_createGroup, headers: headers, stream: NSInputStream(data: imageData!)).responseJSON { response in
            //
            SVProgressHUD.dismiss()
            print("response =\(response.description)")
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    
                    let json = JSON(value)
                    print("create group = \(json.description)")
                    let status = json["status"].int!
                    
                    switch status {
                        
                    case 1 ://创建成功
                        
                        print("create ..........")
                        print(json["groupportraituri"].string!)
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        print(response)

                        
                        
                    default:
                        print(response)
                        self.view.makeToast("创建失败,请再试一遍", duration: 3.0, position: CSToastPositionCenter, style: style)
                        
                    }
                    
                }
                
            case .Failure:
                
                self.view.makeToast("网络出现问题", duration: 2.0, position: CSToastPositionCenter, style: style)
            }
            
        }
            
            
            
            //
        }
        
    }


//团的种类选择
extension HGCreateGController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return HGFlags.groupTypes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return HGFlags.groupTypes[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        self.selectedGroup = row
        
    }
    
}

extension HGCreateGController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.groupIcon = image
        self.groupIconView.image = image

    }
    
    //Mark：构建上传图片事件
    func tapUploadImage(tap: UIGestureRecognizer) {
        
        if tap.state == .Ended {
            
            
            let ac = UIAlertController(title: "上传头像", message: nil, preferredStyle: .ActionSheet)
            
            let act1 = UIAlertAction(title: "拍照获取", style: .Default, handler: { (action) in
                
                let sourceTpe = UIImagePickerControllerSourceType.Camera
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = sourceTpe
                self.presentViewController(imagePicker, animated: true, completion: nil)
            })
            
            let act2 = UIAlertAction(title: "相册获取", style: .Default, handler: { (action) in
                
                let sourceTpe = UIImagePickerControllerSourceType.PhotoLibrary
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = sourceTpe
                self.presentViewController(imagePicker, animated: true, completion: nil)
            })
            
            let act3 = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
                
                ac.dismissViewControllerAnimated(true, completion: nil)
                
            })
            
            ac.addAction(act1)
            ac.addAction(act2)
            ac.addAction(act3)
            
            self.presentViewController(ac, animated: true, completion: nil)
            
        }
        
    }

}

