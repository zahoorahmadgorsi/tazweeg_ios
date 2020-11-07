//
//  ChangeLanguageCell.swift
//  Tazweeg
//
//  Created by iMac on 5/5/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

class ChangeLanguageCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var imgSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
