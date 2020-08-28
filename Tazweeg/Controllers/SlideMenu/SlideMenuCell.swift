//
//  LeftMenuCell.swift
//  KOLLOKI
//
//  Created by Naveed ur Rehman on 29/08/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MOLH

class SlideMenuCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewIsEnabled: UIView!
    @IBOutlet weak var switchIsEnabled: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
