//
//  HistoryVC.swift
//  Speedie
//
//  Created by MAC on 20/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import Alamofire
class HistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableOut: UITableView!
    var tempDict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDetails = Store().getUserCredentials()
        print("userDetails--------\(userDetails)")
        let user_ID = String(userDetails.value(forKey: "id") as! Int)
        myAlbumListAPI(id: user_ID, Token: userDetails.value(forKey: "token") as! String)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableOut.dequeueReusableCell(withIdentifier: "cell") as! HistoryCell
        //     cell.imgOut.layer.cornerRadius = cell.imgOut.frame.size.width/2
        //    cell.imgOut.clipsToBounds = true
        return cell
    }

    //MARK:- historyAPI API
    func historyAPI(id:String, Token:String) {
        startProgressHuddAnimating()
        Alamofire.request(
            URL(string: "\(apiLink)/Speedie")!,
            method: .post,
            parameters: [
                "action": "28",
                "id": "\(id)",
                "token" : "\(Token)"
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
                print("value-- \(self.tempDict.value(forKey: "status") ??  String())")
                if "\(self.tempDict.value(forKey: "status") ??  String())"  == "1"
                {
                    print("SUcessss=====")
                    self.tableOut.isHidden = false
                    
                }
                else if "\(self.tempDict.value(forKey: "status") ??  String())" == "2"
                {
                    //Logout
                    print("invalid token")
                    self.stopProgressHuddAnimating()
                }
                else
                {
                   print("0000")
                    self.tableOut.isHidden = true
                    let noDataLab = UILabel()
                    noDataLab.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 21)
                    noDataLab.text = "No data found"
                    //noDataLab.font = UIFont(descriptor: Poppins-SemiBold, size: 16)
                    noDataLab.textAlignment = .center
                    self.view.addSubview(noDataLab)
                    self.stopProgressHuddAnimating()
                }
        }
        
    }
    // MARK: myAlbumListAPI API
    func myAlbumListAPI(id:String, Token:String) {
        
        let param: NSDictionary =
            [
                "action": "28",
                "id": "\(id)",
                "token" : "\(Token)"
                ]
        print("param==========\(param)")
        Alamofire.request("https://speedie.ng/Speedie", method:.post, parameters:param as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value as? NSDictionary
                {
                    //print(response.result.value as Any)
                    //print(data)
                    self.tempDict = data
                    print("the dict data=====\(self.tempDict)")
                    let  statusStr:String = String(format: "%@",self.tempDict .value(forKey: "status") as! CVarArg) as CVarArg as! String
                    // print(statusStr)
                    if(statusStr == "1")
                    {
                        print("Success")
                      //  self.dataAry = self.tempDict .value(forKeyPath: "data") as! NSArray
                        
                     //   self.tableOut.reloadData()
                    }
                    else if(statusStr == "0")
                    {
                        self.alertMethod(Title: "Alert", Message: "You have no pending deliveries.")
                    }
                }
                break
            case .failure(_):
                self.alertMethod(Title: "Alert", Message: "Internet Connection Error..!")
                print(response.result.error as Any)
                break
            }
            self.stopLoader()
        }
    }
}
