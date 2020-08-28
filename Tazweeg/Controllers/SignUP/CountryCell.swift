//
//  CountryCell.swift
//  Tazweeg
//
//  Created by iMac on 06/02/2020.
//  Copyright © 2020 Tazweeg. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    override func layoutSubviews(){
//        super.layoutSubviews()
//    }
}
