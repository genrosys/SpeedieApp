//
//  OtpVC.swift
//  Speedie
//
//  Created by Sierra on 2/1/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import Alamofire
import PinCodeTextField
class OtpVC: UIViewController,UITextFieldDelegate {

   
    @IBOutlet var otpTF: PinCodeTextField!
    @IBOutlet var PhoneNoLabOut: UILabel!
    
    var mobileNoPass = String()
     var randomNum = String()
    var tempDict = NSDictionary()
    var otpVal = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("The mobile noo is====\(mobileNoPass)")
      PhoneNoLabOut.text = "Enter the 4 digits code sent to you at \(mobileNoPass)"
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.otpTF.becomeFirstResponder()
        }
        otpTF.delegate = self
        otpTF.keyboardType = .numberPad
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let randomID: UInt = UInt(arc4random() % 9000 + 1000)
        //create the random number.
        randomNum = "\(randomID)"
        alertMethod(Title: "OPT", Message: "OPT is \(randomNum)")
    }
    //MARK:- Otp TextField
    
    
    //MARK:- Textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            if ((textField.text?.characters.count)!+string.characters.count) <= 1{
                return true
            }else{
                return false
            }
       
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        //      crossBtnOut.isHidden = false
    }
    
    @IBAction func NextBtnAct(_ sender: Any) {
        print("str-------\(otpVal)")
        if otpVal.characters.count == 4{
            if randomNum == otpVal{
                CheckLoginAPI()
            }else{
                alertMethod(Title: "Alert", Message: "Enter valid OPT")
            }
        }
    }
    
    @IBAction func ResndBtnAct(_ sender: Any) {
         let randomID: UInt = UInt(arc4random() % 9000 + 1000)
        randomNum = "\(randomID)"
        alertMethod(Title: "OPT", Message: "OPT is \(randomNum)")
    }
    
    @IBAction func backBtnAct(_ sender: Any) {     
        self.navigationController?.popViewController(animated: true)
        
    }
    //MARK:- CheckLoginAPI
    func CheckLoginAPI() {
       startProgressHuddAnimating()
        Alamofire.request(
            URL(string: "\(apiLink)/Speedie")!,
            method: .post,
            parameters: [
                "action": "16",
                "custmobile" : mobileNoPass
            ])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    // Collection(nil)
                    return
                }
                self.tempDict = (response.result.value as? NSDictionary)!
                print("The tempDict is =====\(self.tempDict)")
               // print("value-- \(self.tempDict.value(forKey: "status") ??  String()))")
                if (self.tempDict.value(forKey: "status") as? String) == "1"
                {
                    
                   let HomeVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as!HomeVC
                    UserDefaults.standard.set(true, forKey: "keepLoginvalCustmer")
                    self.navigationController?.pushViewController(HomeVCobjct, animated: true)
                    
                }
                else
                {
            let UserRegistrationDetailVCobjct = self.storyboard?.instantiateViewController(withIdentifier:"UserRegistrationDetailVC") as! UserRegistrationDetailVC
                    UserRegistrationDetailVCobjct.C_PhoneNumber = self.mobileNoPass
                    self.navigationController?.pushViewController(UserRegistrationDetailVCobjct, animated: true)
                }
                self.stopProgressHuddAnimating()

        }
        stopProgressHuddAnimating()
    }
}
extension OtpVC: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        print("value changed: \(value)")
        otpVal = value
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}
