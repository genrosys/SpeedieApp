//
//  MenuTable_Cell.swift
//  Speedie
//
//  Created by MAC on 07/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class MenuTable_Cell: UITableViewCell {

    @IBOutlet var nameLab: UILabel!
    @IBOutlet var imgOut: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
