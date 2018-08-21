//
//  HistoryMainVC.swift
//  Speedie
//
//  Created by MAC on 20/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import CarbonKit
class HistoryMainVC: UIViewController,CarbonTabSwipeNavigationDelegate {
    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         items = ["COMPLETED", "PENDING"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        style()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
    }
    //MARK:- CARBONKIT Method
    func style() {
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
        self.navigationController!.navigationBar.barTintColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
        self.navigationController!.navigationBar.barStyle = .black
        
        carbonTabSwipeNavigation.toolbar.isTranslucent = true
        carbonTabSwipeNavigation.setIndicatorColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        carbonTabSwipeNavigation.setTabExtraWidth(0)
        
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth((self.view.frame.size.width/2.0), forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth((self.view.frame.size.width/2.0), forSegmentAt: 1)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black.withAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), font: UIFont.boldSystemFont(ofSize: 14))
        
    }
    //MARK:- CarbonKit Delegates
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            return self.storyboard!.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        case 1:
            return self.storyboard!.instantiateViewController(withIdentifier: "PendingVC") as! PendingVC
           
        default: break
            
            
        }
        return self
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
        
    }
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
