//
//  PhoneNoVCViewController.swift
//  Speedie
//
//  Created by Sierra on 2/1/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class PhoneNoVCViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var phoneNoTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var PopViewOut: UIView!
    @IBOutlet weak var radioBtnOut: UIButton!
    var tempDict = NSDictionary()
    var checkVal = !Bool()
     var T_Cval = String()
    var backVal = String()
    var phoneNoFromLogin = String()
    override func viewDidLoad() {
        super.viewDidLoad()
         T_Cval = ""
        if phoneNoFromLogin.characters.count != 0{
            phoneNoTF.text = phoneNoFromLogin
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK:- Textfield 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNoTF {
            
            if ((textField.text?.characters.count)!+string.characters.count) <= 11{
                return true
            }
            return false
        }
        return true   //     return true0
    }

    @IBAction func radioBtnAct(_ sender: Any) {
        if checkVal==true {
            
            radioBtnOut.setImage(UIImage(named: "checkRadio"), for: .normal)
            checkVal = false
            T_Cval = "1"
        }
        else {
            radioBtnOut.setImage(UIImage(named: "uncheckRadio"), for: .normal)
            checkVal = true
            T_Cval = ""
        }

    }
    
    @IBAction func NextBtnAct(_ sender: Any) {
        if range(phoneNoTF).characters.count == 0 || range(phoneNoTF).characters.count < 11
        {
            alertMethod(Title: "Alert", Message: "Mobile number not valid")
        }
            else if T_Cval == ""
        {
            alertMethod(Title: "Alert", Message: "Agree terms And conditions")
        }
        else{
            CheckPhoneNoAPI()
        }
 
//        let OPTVCobjct = self.storyboard?.instantiateViewController(withIdentifier:"OtpVC") as! OtpVC
//        self.navigationController?.pushViewController(OPTVCobjct, animated: true)
    }
    
    @IBAction func TnCbtnAct(_ sender: Any) {
        self.PopViewOut.isHidden = false
    }
    
    @IBAction func cancelBtnAct(_ sender: Any) {
         self.PopViewOut.isHidden = true
    }
    
    @IBAction func okBtnAct(_ sender: Any) {
         self.PopViewOut.isHidden = true
    }
    
    @IBAction func termNconditionBtnAct(_ sender: Any) {
        
        guard let url = URL(string: "\(apiLink)terms.jsp") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK:- CheckPhoneNoAPI
    func CheckPhoneNoAPI() {
      
        startProgressHuddAnimating()
        Alamofire.request(
            URL(string: "\(apiLink)/MStatus")!,
            method: .post,
            parameters: [
                "custmobile": String(format: phoneNoTF.text!)
            ])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    // Collection(nil)
                    return
                }
                
                self.tempDict = (response.result.value as? NSDictionary)!
                print("self.tempDict------------\(self.tempDict)")
                print("value-- \(self.tempDict.value(forKey: "regStatus") ??  String()))")
                if (self.tempDict.value(forKey: "status") as? String) == "0"
                {
                    let OPTVCobjct = self.storyboard?.instantiateViewController(withIdentifier:"OtpVC") as! OtpVC
                    print(self.phoneNoTF.text!)
                    OPTVCobjct.mobileNoPass = self.phoneNoTF.text!
                    self.navigationController?.pushViewController(OPTVCobjct, animated: true)
                }
                    else
                    {
                        if (self.tempDict.value(forKey: "regStatus") as? String) == "Active"
                        {
                            let LoginVCobjct = self.storyboard?.instantiateViewController(withIdentifier:"LoginVC") as! LoginVC
                            LoginVCobjct.phoneNoPass = self.phoneNoTF.text!
                            self.navigationController?.pushViewController(LoginVCobjct, animated: true)
                        }
                            else
                            {
                       self.alertMethod(Title: "Your Account is currently deactivated", Message: "If you want to activate your account, Please email on custom@speedie.ng" +  "\n Thanks" + "\n Speedie Team")
                        }
                        self.stopProgressHuddAnimating()
                    }
        }
         stopProgressHuddAnimating()
    }
}
