//
//  GroupedSettingsCell.swift
//  Tazweeg
//
//  Created by iMac on 22/02/2020.
//  Copyright © 2020 Tazweeg. All rights reserved.
//
import UIKit
import MOLH

//protocol ContactUsCellDelegate {
//    func contactUsTapped(tag: Int)
//}

class GroupedSettingsCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewIsEnabled: UIView!
    @IBOutlet weak var switchIsEnabled: UISwitch!
    @IBOutlet weak var svSettings: UIStackView!
    @IBOutlet weak var svContactUs: UIStackView!
    
//    var delegate: ContactUsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    @IBAction func btnTapped(_ sender: Any) {
//        let btn = sender as! UIButton
//        delegate?.contactUsTapped(tag: btn.tag)
//    }
    
}

