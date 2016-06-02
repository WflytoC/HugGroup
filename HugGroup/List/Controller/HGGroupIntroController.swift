//
//  HGGroupIntroController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/21/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

private let ID = "group_info"
private let items = [["团成员","团分类"],["分享团","团二维码"]]

class HGGroupIntroController: UIViewController {

    var model: HGGroupModel!
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.buildTableView()
        HGUtils.setString("init", key: HGFlags.ud_tmp)
    }



}


extension HGGroupIntroController: UITableViewDataSource,UITableViewDelegate {
    
    func buildTableView() -> Void {
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.view.addSubview(self.tableView)
        
        let header = HGHeadView(frame: CGRectMake(0, 0, 0, 150), icon: self.model.groupportraituri, info: self.model.groupinfo)
        self.tableView.registerNib(UINib.init(nibName: "HGIntroCell", bundle: nil), forCellReuseIdentifier: ID)
        self.tableView.tableHeaderView = header
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return items.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let place = (indexPath.section,indexPath.row)
        
        switch (place) {
        case (0,0):
            //切换到团的成员页面
            let memController = HGGroupMemberController()
            memController.model = self.model
            self.navigationController!.pushViewController(memController, animated: true)
            
        case (1,0):
            
            HGShareModule.shareGroup("\(HGFlags.schema_HugGroup)\(model.groupid)", image: nil)
            
        case (1,1):
            
            let codeController = HGUtils.viewControllerWithIdentifier("single_qcode", storyboardName: "Single") as! HGCodeController
            codeController.groupID = self.model.groupid
            self.navigationController!.pushViewController(codeController, animated: true)
            
        default:
            
            break
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ID) as! HGIntroCell
        cell.infoView.text = items[indexPath.section][indexPath.row]
       
        let place = (indexPath.section,indexPath.row)
        if place == (0,0){
            
            cell.accessoryType = .DisclosureIndicator
        } else if place == (0,1) {
            
            cell.explainView.hidden = false
            cell.explainView.text = self.model.groupclass
        }
        
        return cell
    }
    
}
