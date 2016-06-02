//
//  HGInfoController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/12/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit
import Toast
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Toast

class HGInfoController: UIViewController {

    
    var selectedProvince: String = "北京"
    var selectedCity: String = "北京"
    
    var sex: String = "男"
    
    let provinces = HGUtils.getCities().provinces
    let cities = HGUtils.getCities().cities
    
    //Mark: IBOutlet
    
    @IBOutlet weak var iconViewe: UIImageView!
    
    @IBOutlet weak var nickField: UITextField!
    
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBOutlet weak var sexChoiceBtn: UIButton!
    
    @IBOutlet weak var citiesPicker: UIPickerView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconViewe.layer.cornerRadius = 45
        self.iconViewe.clipsToBounds = true
        self.sexChoiceBtn.layer.cornerRadius = 20
        self.saveBtn.layer.cornerRadius = 6
        self.cancelBtn.layer.cornerRadius = 6
        self.citiesPicker.dataSource = self
        self.citiesPicker.delegate = self
        
        self.nickField.text = HGUtils.valueFromKey(HGFlags.ud_nickName)
        
        if HGUtils.valueFromKey(HGFlags.ud_sex) == "女" {
            self.sex = "女"
            self.sexChoiceBtn.backgroundColor = UIColor.redColor()
            self.sexLabel.textColor = UIColor.redColor()
        }
        
        self.iconViewe.image = UIImage(contentsOfFile: HGUtils.createFilePath("15527113304.jpg"))
        //
        self.iconViewe.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(HGInfoController.tapUploadImage(_:)))
        self.iconViewe.addGestureRecognizer(tap)

    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.nickField.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark: IBAction
    
    
    @IBAction func sexAction(sender: AnyObject) {
        
        if self.sex == "男" {
            
            self.sex = "女"
            self.sexChoiceBtn.backgroundColor = UIColor.redColor()
            self.sexLabel.textColor = UIColor.redColor()
            self.sexLabel.text = "女"
        } else {
            
            self.sex = "男"
            self.sexChoiceBtn.backgroundColor = UIColor.blueColor()
            self.sexLabel.textColor = UIColor.blueColor()
            self.sexLabel.text = "男"
        }
        
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        let nick = self.nickField.text!
        
        if nick == "" {
            
            
            self.view.makeToast("昵称不能为空", duration: 2.0, position: CSToastPositionCenter, style: style)
            
            return
        }
        
        SVProgressHUD.showWithStatus("修改信息中....")

        
        
        Alamofire.request(.POST, HGFlags.url_userUpdateInfo, parameters: ["phone": HGUtils.valueFromKey(HGFlags.ud_phone)!,"name": nick,"sex": self.sex,"location": "\(self.selectedProvince)\(self.selectedCity)"], encoding: .URL, headers: [: ]).validate().responseJSON { response in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            case .Success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let status = json["status"].int!
                    
                    if status == 1 {
                        
                        HGUtils.setString(self.sex, key: HGFlags.ud_sex)
                        HGUtils.setString("\(self.selectedProvince)\(self.selectedCity)", key: HGFlags.ud_location)
                        HGUtils.setString(nick, key: HGFlags.ud_nickName)
                        self.view.makeToast("信息修改成功", duration: 2.0, position: CSToastPositionCenter, style: style)
                        
                        
                        
                    } else {
                        
                        self.view.makeToast("信息修改失败", duration: 2.0, position: CSToastPositionCenter, style: style)
                    }
                }
                
            case .Failure:
                
                    self.view.makeToast("信息修改失败", duration: 2.0, position: CSToastPositionCenter, style: style)
                
        }
        
        
        }
        
        
        //
        
        
        
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


}

extension HGInfoController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return provinces.count
        }
        
        let rowProvince = pickerView.selectedRowInComponent(0)
        let province = self.provinces[rowProvince]
        let items = self.cities[province]!
        
        return items.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            return provinces[row]
        }
        
        let rowProvince = pickerView.selectedRowInComponent(0)
        let province = self.provinces[rowProvince]
        let items = self.cities[province]!
        
        return items[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            
            self.citiesPicker.reloadComponent(1)
            self.citiesPicker.selectRow(0, inComponent: 1, animated: true)
            self.selectedProvince = self.provinces[row]
            self.selectedCity = self.cities[self.provinces[row]]![0]
            
        } else {
            
            self.selectedCity = self.cities[self.selectedProvince]![row]
        }
        
        
    }
    
}

extension HGInfoController {
    
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


extension HGInfoController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.iconViewe.image = image
        //更新本地头像
        
        var imageData: NSData?
        
        if let JPEGdata = UIImageJPEGRepresentation(image, 0.5) {
            
            imageData = JPEGdata
        } else  if let PNGdata = UIImagePNGRepresentation(image) {
            
            imageData = PNGdata
        }
        
        
        //上传头像到服务器
        SVProgressHUD.showWithStatus("上传头像中...")
        
        //设置Toast样式
        let style = CSToastStyle(defaultStyle: ())
        style.messageColor = UIColor.redColor()
        
        Alamofire.upload(.POST, HGFlags.url_userUploadIcon, headers: ["phone": HGUtils.valueFromKey(HGFlags.ud_phone)!], stream: NSInputStream(data: imageData!)).validate().responseJSON { (response) in
            
            SVProgressHUD.dismiss()
            switch response.result {
                
            
            case .Success:
                if let value = response.result.value {
                    
                    
                    let json = JSON(value)
                    let status = json["status"].int!
                    switch status {
                        

                    case 1 :
                        HGUtils.setString(json["portraitUri"].string!, key: HGFlags.ud_portraitUri)
                        HGUtils.downloadIcon()
                        self.view.makeToast("图片上传成功", duration: 2.0, position: CSToastPositionCenter, style: style)
                        
                        
                    default:
                        self.view.makeToast("图片上传失败", duration: 2.0, position: CSToastPositionCenter, style: style)
                        
                    }
                    
                }
                
            case .Failure(let error):
                
                self.view.makeToast("网络出现问题", duration: 2.0, position: CSToastPositionCenter, style: style)
                print(error)
            }
            
        }
        
        
    }
}







