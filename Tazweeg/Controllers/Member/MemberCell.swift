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
    @IBOutlet weak var lblMemberMatchCount: UILabel!
    @IBOutlet weak var viewMatchCount: UIView!
    @IBOutlet weak var imgMatchCount: UIImageView!
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblMemberPhoneNumber: UILabel!
    @IBOutlet weak var lblMemberAge: UILabel!
    @IBOutlet weak var lblMemberEmirate: UILabel!
    @IBOutlet weak var lblMemberConsultant: UILabel!
    var userID : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        if MOLHLanguage.isRTLLanguage() {
            self.lblMemberCode.textAlignment = .right
            self.lblMemberName.textAlignment = .right
            self.lblMemberPhoneNumber.textAlignment = .right
            self.lblMemberEmirate.textAlignment = .right
            self.lblMemberConsultant.textAlignment = .right
            self.lblMemberMatchCount.textAlignment = .right
        }else{
            self.lblMemberCode.textAlignment = .left
            self.lblMemberName.textAlignment = .left
            self.lblMemberPhoneNumber.textAlignment = .left
            self.lblMemberEmirate.textAlignment = .left
            self.lblMemberConsultant.textAlignment = .left
            self.lblMemberMatchCount.textAlignment = .left
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
