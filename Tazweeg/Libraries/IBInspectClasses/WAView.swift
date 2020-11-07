//
//  WAView.swift
//  Iptikar PromotionS
//
//  Created by Waqas Ali on 12/25/15.
//  Copyright © 2015 Waqas Ali. All rights reserved.
//

import UIKit

@IBDesignable class WAView: UIView {


    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var backgroundColors: UIColor = UIColor.clear {
        didSet {
            self.layer.backgroundColor = backgroundColors.cgColor
        }
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
            if borderWidth != 0 {
                borderWidth = 1
            }
        }
    }
    
    //MARK:- START
    //MARK:- Making Shadow of the UIView
    @IBInspectable var wantShadow: Bool = false {
        didSet {
            if !changeShadowPath {
                self.layoutIfNeeded()
                self.layoutSubviews()
//                self.layer.shouldRasterize = wantShadow
            }
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            if wantShadow {
                self.layer.shadowColor = shadowColor.cgColor
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            if wantShadow {
                self.layer.shadowOpacity = shadowOpacity
            }
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            if wantShadow {
                self.layer.shadowOffset = shadowOffset
            }
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            if wantShadow {
                self.layer.shadowRadius = shadowRadius
            }
        }
    }
    
    @IBInspectable var changeShadowPath: Bool = false {
        didSet {
            if changeShadowPath == true {
                self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            }
        }
    }
    
    //MARK:- END
    
   func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func getWAViewBounds() -> CGRect {
        return self.bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
