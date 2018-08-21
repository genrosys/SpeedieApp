//
//  StoreClass.swift
//  Speedie
//
//  Created by MAC on 06/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//


//Call //Store().getUserCredentials()// this to get value by Sagar

import Foundation
class Store {
 
    //MARK:- User Credentials
    func storeUserCredentials(User_Details:NSDictionary)
    {
        UserDefaults.standard.set(User_Details, forKey: "User_Details")
    }
    func getUserCredentials() -> NSDictionary {
        return UserDefaults.standard.value(forKey: "User_Details") as! NSDictionary
    }
    
    
}
