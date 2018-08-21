//
//  PromotionsVC.swift
//  Speedie
//
//  Created by MAC on 24/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class PromotionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
    }
    @IBAction func sharePromoBtnAct(_ sender: Any) {
        let text = "Sagar has given you a free Speedie ride. Sign up with my invitation code SPDSS456(up to ₦ 500). Redeem it"
        let urlStr = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
        let shareAll = [text , urlStr as Any] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
