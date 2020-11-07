//
//  ChangePassView.swift
//  Pedia Club
//
//  Created by Naveed ur Rehman on 17/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit

protocol SignatureViewDelegate {
    func didTapSubmit()
    func didTapClear()
    func didTapCancel()
}

class SignatureView: UIView{
    
    
    @IBOutlet weak var signView: YPDrawSignatureView!
    @IBOutlet weak var doneBtn: WAButton!
    @IBOutlet weak var clearBtn: WAButton!
    
    var delegate: SignatureViewDelegate?
    var blurrView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nibSetup()
        doneBtn.setTitle("done".localized, for: UIControlState.normal)
        clearBtn.setTitle("clear".localized, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
   
    private func nibSetup() {
        self.changeFont()
        
        backgroundColor = .clear
        
        let view = instanceFromNib()
        view.frame = bounds
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor(hexString: appColors.defaultColor.rawValue).cgColor
        view.layer.borderWidth = 2
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        
        addSubview(view)
        
    }
    
    private func instanceFromNib() -> UIView {
        //        return UINib(nibName: "VideoAttachAlertView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }
   
    @IBAction func cancelTap(_ sender: Any) {
        delegate?.didTapCancel()
    }
    
    @IBAction func doneTap(_ sender: Any) {
        delegate?.didTapSubmit()
    }
    
    @IBAction func clearTap(_ sender: Any) {
        delegate?.didTapClear()
    }
    
}
