//
//  MemberCell.swift
//  Tazweeg
//
//  Created by iMac on 5/18/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit
import MOLH

//Used in Members list for consultant
class MemberCell: UITableViewCell {
    
    @IBOutlet weak var imgMember: UIImageView!
    @IBOutlet weak var lblMemberCode: UILabel!
    @IBOutlet weak var lblChoosingCount: UILabel!
    @IBOutlet weak var viewChoosingCount: UIView!
    @IBOutlet weak var imgChoosingCount: UIImageView!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblMemberPhoneNumber: UILabel!
    @IBOutlet weak var lblMemberAge: UILabel!
    @IBOutlet weak var lblMemberEmirate: UILabel!
    @IBOutlet weak var lblMemberConsultant: UILabel!
    var userID : Int?
    
    @IBOutlet weak var viewMatchingCount: UIStackView!
    @IBOutlet weak var lblMatching: UILabel!
    @IBOutlet weak var lblMatchingCount: UILabel!
    @IBOutlet weak var imgMatchingCount: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblMatching.text = "matching".localized
        if MOLHLanguage.isRTLLanguage() {
            self.lblMemberCode.textAlignment = .right
            self.lblMemberName.textAlignment = .right
            self.lblMemberPhoneNumber.textAlignment = .right
            self.lblMemberEmirate.textAlignment = .right
            self.lblMemberConsultant.textAlignment = .right
            self.lblChoosingCount.textAlignment = .right
            self.lblMatching.textAlignment = .right
        }else{
            self.lblMemberCode.textAlignment = .left
            self.lblMemberName.textAlignment = .left
            self.lblMemberPhoneNumber.textAlignment = .left
            self.lblMemberEmirate.textAlignment = .left
            self.lblMemberConsultant.textAlignment = .left
            self.lblChoosingCount.textAlignment = .left
            self.lblMatching.textAlignment = .left
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
