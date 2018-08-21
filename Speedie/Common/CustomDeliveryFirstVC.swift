//
//  CustomDeliveryFirstVC.swift
//  Speedie
//
//  Created by MAC on 24/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class CustomDeliveryFirstVC: UIViewController,UIWebViewDelegate {
    
// var urlStr = URL(string: "https://speedie.ng/custom.jsp?customerid=\()&token=13620180707060321&mobile=12345678902")
    @IBOutlet var webOut: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startLoader()
        // Do any additional setup after loading the view.
        let userDetails = Store().getUserCredentials()
        let custID = String(userDetails.value(forKey: "id") as! Int)
        let userToken = userDetails.value(forKey: "token") as! String
        let userMob = userDetails.value(forKey: "mobile") as! String
        let urlStr = URL(string: "\(apiLink)/custom.jsp?customerid=\(custID)&token=\(userToken)&mobile=\(userMob)")
        let requestObj = URLRequest(url: urlStr! as URL)
        webOut.loadRequest(requestObj)
        webOut.delegate = self
    }

    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.stopLoader()
    }
}
