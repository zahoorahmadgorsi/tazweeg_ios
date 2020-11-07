//
//  ConsultantCell.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 04/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit


protocol ConsultantCellDelegate {
    func didTapMemberDetail(index: Int)
}

class ConsultantCell: UITableViewCell {

    @IBOutlet weak var usrImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var dob: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var lookingFor: UILabel!
    
    var delegate: ConsultantCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func MemberDetailTap(_ sender: Any) {
        delegate?.didTapMemberDetail(index: self.tag)
    }
}
