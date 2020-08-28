//
//  WATextField.swift
//  Iptikar PromotionS
//
//  Created by Waqas Ali on 1/2/16.
//  Copyright © 2016 Waqas Ali. All rights reserved.
//

import UIKit
import MOLH

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

class WATextField: UITextField {
    
    func isValid() -> Bool {
        if self.text?.isEmpty == true {
            return false
        }
        return true
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
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
    
    /// A UIImage value that set LeftImage to the UITextView
    @IBInspectable open var leftImage:UIImage? {
        didSet {
            if (leftImage != nil) {
                self.applyLeftImage(leftImage!)
            }
        }
    }
    
    /// A UIImage value that set LeftImage to the UITextView
    @IBInspectable var addBottomLine:Bool = false {
        didSet {
            if (addBottomLine) {
//                self.addLineToView()
                self.addLineToView(view: self, position:.LINE_POSITION_BOTTOM, color: UIColor(red: 0/255, green: 174/255, blue: 239/255, alpha: 1.0), width: 1)
            }
        }
    }
    
    //*****************************************************************************
    // Adding line to the uitextfield i.e. email and password has bottom line
    //*****************************************************************************
    //this function is not going edge to edge for ipad
    func addLineToView() {
        let bottomLine = CALayer()
        let width = CGFloat(1.0)
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        bottomLine.backgroundColor = UIColor(red: 0/255, green: 174/255, blue: 239/255, alpha: 1.0).cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.masksToBounds = true
        self.layer.addSublayer(bottomLine)
    }
    
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .LINE_POSITION_TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }
    
    //*****************************************************************************
    // Applying left image to uitextfield i.e. email and password icons at the left
    //*****************************************************************************
    fileprivate func applyLeftImage(_ image: UIImage) {
        let icn : UIImage = image
        let imageView = UIImageView(image: icn)
        
        if MOLHLanguage.isRTLLanguage() {
            imageView.frame = CGRect(x: 5, y: 0, width: icn.size.width, height: icn.size.height )
        }else{
            imageView.frame = CGRect(x: 0, y: 0, width: icn.size.width, height: icn.size.height )
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: icn.size.width + 10, height: icn.size.height))
        view.addSubview(imageView)
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = view
    }

//    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
//        self.layer.addSublayer(border)
//    }
//
//    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
//        self.layer.addSublayer(border)
//    }
//
//    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
//        self.layer.addSublayer(border)
//    }
//
//    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
//        self.layer.addSublayer(border)
//    }
    
    func getWAViewBounds() -> CGRect {
        return self.bounds
    }}
