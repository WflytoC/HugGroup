//
//  HGHomeController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/10/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

private let titleCell = "cell"
private let itemTitles = ["娱乐八卦","数码科技","美食养生","体育竞技","时尚新潮","家居艺术"]

class HGHomeController: UIViewController {
    
    var collectionView: UICollectionView?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buildCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(HGFlags.kScreenWidth/2.0, HGFlags.kScreenWidth/2.0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.collectionView!)
        self.collectionView!.registerNib(UINib.init(nibName: "HGChoiceCell", bundle: nil), forCellWithReuseIdentifier: titleCell)
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        
    }
    
//Mark: IBAction
    
    
    @IBAction func switchSearch(sender: AnyObject) {
        
        let targetVC = HGAllSearchController()
        self.navigationController!.pushViewController(targetVC, animated: true)
        
    }


}


extension HGHomeController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemTitles.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let search = HGSearchController()
        search.type = HGFlags.groupTypes[indexPath.row]
        self.navigationController!.pushViewController(search, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(titleCell, forIndexPath: indexPath) as! HGChoiceCell
        if (indexPath.item - 1) % 4 == 0 || (indexPath.item - 2) % 4 == 0 {
            
            cell.backgroundColor = UIColor.blackColor()
        }
        cell.titleView.text = itemTitles[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
}
