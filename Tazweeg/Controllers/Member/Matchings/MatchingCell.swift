//
//  MatchingCell.swift
//  Tazweeg
//
//  Created by iMac on 5/13/19.
//  Copyright © 2019 Glowingsoft. All rights reserved.
//

import UIKit

//protocol MatchingCellDelegate {
//    func didTapMatch(index: Int)
//}

class MatchingCell: UITableViewCell {
    
    @IBOutlet weak var lblUserCode: UILabel!
    @IBOutlet weak var lblConsultantNumber: UILabel!
    @IBOutlet weak var imgPhone: UIImageView!
//    var delegate: MatchingCellDelegate?
    @IBOutlet weak var lblConsultantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        print(" imgPhoneTapped ")
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
    
//    @IBAction func MemberDetailTap(_ sender: Any) {
//        delegate?.didTapMatch(index: self.tag)
//    }
}
