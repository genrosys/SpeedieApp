
//
//  GlobalClass.swift
//  Speedie
//
//  Created by Sierra on 2/2/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import NVActivityIndicatorView

 var progressHudd:MBProgressHUD!
 var window: UIWindow?
var activityData = ActivityData( type: .ballScaleRipple)
extension UIViewController{
    // MARK:- For Alert
    func alertMethod(Title: String ,Message: String) {
        let alert = UIAlertController(title:Title, message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: textField trimmingCharacters
    func range(_ textField: UITextField) -> String{
        return textField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /*********************LOADER************************/
    func startLoader(){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    func stopLoader(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    func loaderTitle(Title: String){
        NVActivityIndicatorPresenter.sharedInstance.setMessage(Title)
    }
    func startProgressHuddAnimating()
    {
        progressHudd = MBProgressHUD.showAdded(to: self.view, animated: false)
        
        progressHudd.backgroundView.color = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.15)
        
        progressHudd.label.text = "please wait"
    }
    //MARK:Progress Hudd hide Method
    
    func stopProgressHuddAnimating()
    {
        progressHudd?.hide(animated: true)
    }
}
