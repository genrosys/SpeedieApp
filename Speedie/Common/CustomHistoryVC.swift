//
//  CustomHistoryVC.swift
//  Speedie
//
//  Created by MAC on 24/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class CustomHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableOut: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        tableOut.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let  cell = tableOut.dequeueReusableCell(withIdentifier: "cell") as! CustomHistoryCell
             cell.orderIdBtnOut.layer.cornerRadius = cell.orderIdBtnOut.frame.size.height/2
            cell.orderIdBtnOut.clipsToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
        },completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let CustompendingDetailVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "CustompendingDetailVC") as! CustompendingDetailVC
        self.navigationController?.pushViewController(CustompendingDetailVCobjct, animated: true)
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.1
    }

}
