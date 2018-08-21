//
//  LoginVC.swift
//  Speedie
//
//  Created by Sierra on 2/2/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
class LoginVC: UIViewController {

    @IBOutlet weak var popUpViewOut: UIView!
    @IBOutlet var mobNoTF: SkyFloatingLabelTextField!
    @IBOutlet var psdTF: SkyFloatingLabelTextField!
    
    var phoneNoPass = String()
    var tempDict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        mobNoTF.text = phoneNoPass
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    @IBAction func forgotPsdAct(_ sender: Any) {
        popUpViewOut.isHidden = false
    }
    
    @IBAction func cancelBtnAct(_ sender: Any) {
        popUpViewOut.isHidden = true
    }
    
    @IBAction func OkBtnAct(_ sender: Any) {
        popUpViewOut.isHidden = false

    }
    
    @IBAction func nextBtnAct(_ sender: Any) {
        
        if range(mobNoTF).characters.count == 0 || range(psdTF).characters.count == 0{
            self.alertMethod(Title: "Alert", Message: "Mobile number or Password missing")
        }else if range(mobNoTF).characters.count != 11{
            self.alertMethod(Title: "Alert", Message: "Mobile number is not valid")
        }else{
            loginUserAPI()
        }
    }
    
    @IBAction func signUpBtnAct(_ sender: Any) {
        let PhoneNoVCViewControllerObjct = self.storyboard?.instantiateViewController(withIdentifier:"PhoneNoVCViewController") as! PhoneNoVCViewController
       PhoneNoVCViewControllerObjct.phoneNoFromLogin = phoneNoPass
        self.navigationController?.pushViewController(PhoneNoVCViewControllerObjct, animated: false)
    }
    
    //MARK:- loginUserAPI
    func loginUserAPI() {
        startProgressHuddAnimating()
        startProgressHuddAnimating()
        Alamofire.request(
            URL(string: "\(apiLink)/checkPass")!,
            method: .post,
            parameters: [
                "custmobile": mobNoTF.text!,
                "password" : psdTF.text!
            ])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    // Collection(nil)
                   self.stopProgressHuddAnimating()
                    return
                }
                self.tempDict = (response.result.value as? NSDictionary)!
                print("The tempDict is =====\(self.tempDict)")
                // print("value-- \(self.tempDict.value(forKey: "status") ??  String()))")
                if (self.tempDict.value(forKey: "status") as? String) == "1"
                {
                    let HomeVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as!HomeVC
                    Store().storeUserCredentials(User_Details: self.tempDict)
                    UserDefaults.standard.set(true, forKey: "keepLoginvalCustmer")
                    self.navigationController?.pushViewController(HomeVCobjct, animated: true)
                    
                }
                else
                {
                    self.alertMethod(Title: "Alert", Message: "Something went wrong")
                }
                self.stopProgressHuddAnimating()
        }
        stopProgressHuddAnimating()
    }

}
