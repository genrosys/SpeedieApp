//
//  PaymentVC.swift
//  Speedie
//
//  Created by MAC on 20/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet var cardView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
    }

    @IBAction func cashBtnAct(_ sender: Any) {
        self.alertMethod(Title: "Pay for deliveries in cash", Message: "Cash payment to be collected from user at the arrival of rider before the delivery process")
    }
    
    @IBAction func payByCardBtnAct(_ sender: Any) {
        cardView.isHidden = false
    }
    
    @IBAction func updatePayBtn(_ sender: Any) {
        cardView.isHidden = false
    }
    
    @IBAction func hideCardViewBtnAct(_ sender: Any) {
        cardView.isHidden = true
    }
    
    @IBAction func hideCradViewBtn2Act(_ sender: Any) {
        cardView.isHidden = true
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
