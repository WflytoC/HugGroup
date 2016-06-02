//
//  HGNavController.swift
//  HugGroup
//
//  Created by wcshinestar on 4/17/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

import UIKit

class HGNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        if self.childViewControllers.count > 1 {
            
            self.tabBarController!.tabBar.hidden = true
        }
    }

    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        
        if self.childViewControllers.count == 2 {
            
            self.tabBarController!.tabBar.hidden = false
        }
        return super.popViewControllerAnimated(true)
    }

}
