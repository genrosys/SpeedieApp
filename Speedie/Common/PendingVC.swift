//
//  PendingVC.swift
//  Speedie
//
//  Created by MAC on 20/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class PendingVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableOut: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let  cell = tableOut.dequeueReusableCell(withIdentifier: "cell") as! PendingCell
        //     cell.imgOut.layer.cornerRadius = cell.imgOut.frame.size.width/2
        //    cell.imgOut.clipsToBounds = true
        return cell
    }

}
