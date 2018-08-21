//
//  AboutUsVC.swift
//  Speedie
//
//  Created by MAC on 24/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController,UIWebViewDelegate {

    @IBOutlet var webOut: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let urlStr = URL(string: "https://speedie.ng/about")
        let requestObj = URLRequest(url: urlStr! as URL)
        webOut.loadRequest(requestObj)
        webOut.delegate = self
        self.startLoader()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.stopLoader()
    }

    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
