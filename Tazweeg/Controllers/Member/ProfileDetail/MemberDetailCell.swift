//
//  MemberDetailCell.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 05/11/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

//Used in PersonalInfo and RequiredIno
class MemberDetailCell: UITableViewCell {
    @IBOutlet weak var lblSerialNumber: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblConsultantNumber: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var viewSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if MOLHLanguage.isRTLLanguage() {
            self.lblSerialNumber.textAlignment = .right
            self.lblTitle.textAlignment = .right
            self.lblDetails.textAlignment = .right
        }else{
            self.lblSerialNumber.textAlignment = .left
            self.lblTitle.textAlignment = .left
            self.lblDetails.textAlignment = .left
        }
        //        //defining and adding tap gesture on phone
        let tapGestureOnPhone = UITapGestureRecognizer(target: self, action: #selector(imgPhoneTapped))
        tapGestureOnPhone.numberOfTapsRequired = 1
        tapGestureOnPhone.numberOfTouchesRequired = 1
        imgPhone.isUserInteractionEnabled = true
        imgPhone.addGestureRecognizer(tapGestureOnPhone)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func imgPhoneTapped() {
//        print(" imgPhoneTapped ")
        let number = self.lblConsultantNumber.text
        if number != "" {
            if let url = URL(string: "tel://\(String(describing: number!))"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                // add error message here
                print("Error in imgPhoneTapped")
            }
        }
    }
    
    
}
