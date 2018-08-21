//
//  UserRegistrationDetailVC.swift
//  Speedie
//
//  Created by Sierra on 2/2/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
class UserRegistrationDetailVC: UIViewController {

    @IBOutlet var nameTF: SkyFloatingLabelTextField!
    
    @IBOutlet var emailTF: SkyFloatingLabelTextField!
    
    @IBOutlet var optionalCodeTF: SkyFloatingLabelTextField!
    
    var tempDict = NSDictionary()
    var C_PhoneNumber = String()
    var referalCode = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    @IBAction func nextBtnAct(_ sender: Any) {
        
        referalCode = optionalCodeTF.text!
        if range(nameTF).characters.count == 0 || range(emailTF).characters.count == 0{
            alertMethod(Title: "Alert", Message: "Enter the required fields")
        }
        else if range(nameTF).characters.count == 0{
            referalCode = ""
        }
        else if isValidEmail() == false{
            alertMethod(Title: "Alert", Message: "Please enter valid email address")
        }
        else{
            registerUserAPI()
        }
        
    }
    //MARK: For email Validation check
    func isValidEmail() -> Bool {
        let email = emailTF.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    //MARK:- registerUser API
    func registerUserAPI() {
        startProgressHuddAnimating()
        Alamofire.request(
            URL(string: "\(apiLink)/RegUser")!,
            method: .post,
            parameters: [
                "custfirstName": nameTF.text!,
                "custlastName" : nameTF.text!,
                "custmobile":C_PhoneNumber,
                "custemail":emailTF.text!,
                "custtypeid":"1",
                "referbycode": referalCode
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
                if (self.tempDict.value(forKey: "status") as? String) == "1"
                {

                   
                    let HomeVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as!HomeVC
                     Store().storeUserCredentials(User_Details: self.tempDict)
                    UserDefaults.standard.set(true, forKey: "keepLoginvalCustmer")
                    self.navigationController?.pushViewController(HomeVCobjct, animated: true)
                }
                else
                {
                    
                }
                self.stopProgressHuddAnimating()

        }
        stopProgressHuddAnimating()
    }
}

