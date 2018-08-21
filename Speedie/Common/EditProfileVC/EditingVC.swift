//
//  EditingVC.swift
//  Speedie
//
//  Created by MAC on 19/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import Alamofire
class EditingVC: UIViewController {

    @IBOutlet var FnameViewOut: UIView!
    @IBOutlet var LnameViewOut: UIView!
    @IBOutlet var PnoViewOut: UIView!
    @IBOutlet var emailViewOut: UIView!
    @IBOutlet var psdViewOut: UIView!
    
    @IBOutlet var FnameTF: UITextField!
    @IBOutlet var LnameTF: UITextField!
    @IBOutlet var PnoTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var cPsdTF: UITextField!
    @IBOutlet var conPsdTF: UILabel!
    var viewValuePass = String()
    var userDetails = NSDictionary()
    var tempDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
        // Do any additional setup after loading the view.
        userDetails = Store().getUserCredentials()
        if viewValuePass == "openFname"{
            FnameViewOut.isHidden = false
            FnameTF.text = userDetails.value(forKey: "firstName") as? String
            
        }
        else if viewValuePass == "openLname"{
            LnameViewOut.isHidden = false
            LnameTF.text = userDetails.value(forKey: "lastname") as? String

        }else if viewValuePass == "openPhoneNo"{
            PnoViewOut.isHidden = false
            PnoTF.text = userDetails.value(forKey: "mobile") as? String

        }else if viewValuePass == "openEmail"{
            emailViewOut.isHidden = false
            emailTF.text = userDetails.value(forKey: "email") as? String

        }else if viewValuePass == "openPassword"{
            psdViewOut.isHidden = false
        }
    }
    //MARK:- Btn Actions
    @IBAction func updateFnameBtnAct(_ sender: Any) {
        
    //    let userID = String(userDetails.value(forKey: "id") as! Int)
        print(userDetails.value(forKey: "email") as! String)
     //   updateProfileAPI(id: userID, Token: userDetails.value(forKey: "token") as! String, firstname: FnameTF.text!, lastname: userDetails.value(forKey: "lastname") as! String, mobile: userDetails.value(forKey: "mobile") as! String, email: userDetails.value(forKey: "email") as! String, password: userDetails.value(forKey: "password") as! String, Profileurl: userDetails.value(forKey: "custimageurl") as! String)
       
       
    }
    
    @IBAction func updateLnameBtnAct(_ sender: Any) {
    //    let userID = String(userDetails.value(forKey: "id") as! Int)
     //   updateProfileAPI(id: userID, Token: userDetails.value(forKey: "token") as! String, firstname: userDetails.value(forKey: "firstname") as! String, lastname: LnameTF.text!, mobile: userDetails.value(forKey: "mobile") as! String, email: userDetails.value(forKey: "email") as! String, password: userDetails.value(forKey: "password") as! String, Profileurl: userDetails.value(forKey: "Profileurl") as! String)
    }
    @IBAction func updatePnoBtnAct(_ sender: Any) {
    //    let userID = String(userDetails.value(forKey: "id") as! Int)
     //   updateProfileAPI(id: userID, Token: userDetails.value(forKey: "token") as! String, firstname: userDetails.value(forKey: "firstname") as! String, lastname: userDetails.value(forKey: "lastname") as! String, mobile: PnoTF.text!, email: userDetails.value(forKey: "email") as! String, password: userDetails.value(forKey: "password") as! String, Profileurl: userDetails.value(forKey: "Profileurl") as! String)
    }
    
    @IBAction func updateEmailBtnAct(_ sender: Any) {
     //   let userID = String(userDetails.value(forKey: "id") as! Int)
     //   updateProfileAPI(id: userID, Token: userDetails.value(forKey: "token") as! String, firstname: userDetails.value(forKey: "firstname") as! String, lastname: userDetails.value(forKey: "lastname") as! String, mobile: userDetails.value(forKey: "mobile") as! String, email: emailTF.text!, password: userDetails.value(forKey: "password") as! String, Profileurl: userDetails.value(forKey: "Profileurl") as! String)
        
    }
    
    @IBAction func updatePsdBtnAct(_ sender: Any) {
        if cPsdTF.text! != conPsdTF.text! {
            self.alertMethod(Title: "Alert", Message: "Password not matched")
        }else{
     //       let userID = String(userDetails.value(forKey: "id") as! Int)
     //       updateProfileAPI(id: userID, Token: userDetails.value(forKey: "token") as! String, firstname: userDetails.value(forKey: "firstname") as! String, lastname: userDetails.value(forKey: "lastname") as! String, mobile: userDetails.value(forKey: "mobile") as! String, email: userDetails.value(forKey: "email") as! String, password: conPsdTF.text!, Profileurl: userDetails.value(forKey: "Profileurl") as! String)
            
        }
    }
    @IBAction func backBtnACtt(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:- Get Profile API
    func updateProfileAPI(id:String, Token:String, firstname: String, lastname:String, mobile:String, email:String, password:String, Profileurl:String) {
         startProgressHuddAnimating()
         Alamofire.request(
         URL(string: "\(apiLink)/Speedie")!,
         method: .post,
         parameters: [
         "action": "21",
            "id": "\(id)",
            "token" : "\(Token)",
            "firstname": "\(firstname)",
            "lastname":"\(lastname)",
            "mobile":"\(mobile)",
            "email":"\(email)",
            "password": "\(password)",
            "Profileurl" : "\(Profileurl)",
            "usertype": "1"
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
         if (self.tempDict.value(forKey: "status") as? String) == "1"
         {
            print("SUcessss=====")
             Store().storeUserCredentials(User_Details: self.tempDict)
            self.stopProgressHuddAnimating()

         }
         else
         {
    
         self.stopProgressHuddAnimating()
    
         }
    
         }
        /// stopProgressHuddAnimating()
            
         }
    
    
    
   
}
