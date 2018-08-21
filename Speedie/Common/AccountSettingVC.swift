//
//  AccountSettingVC.swift
//  Speedie
//
//  Created by MAC on 25/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class AccountSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
    }
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signOutBtnAct(_ sender: Any) {
        //PhoneNoVCViewController
        let PhoneNoVCViewControllerobjct = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNoVCViewController") as! PhoneNoVCViewController
        UserDefaults.standard.removeObject(forKey: "User_Details")
         UserDefaults.standard.removeObject(forKey: "keepLoginvalCustmer")
        self.navigationController?.pushViewController(PhoneNoVCViewControllerobjct, animated: true)
    }
    
}
