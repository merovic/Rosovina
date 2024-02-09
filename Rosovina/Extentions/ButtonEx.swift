//
//  ButtonEX.swift
//  Wever
//
//  Created by Amir Ahmed on 24/06/2022.
//

import Foundation
import UIKit

extension UIButton{
    
    func prettyHareefButton(radius: Float){
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 35.0  //1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = CGFloat(radius)
        
        let insetAmount = 12 / 2
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -CGFloat(insetAmount), bottom: 0, right: CGFloat(insetAmount))
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(insetAmount), bottom: 0, right: -CGFloat(insetAmount))
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(insetAmount), bottom: 0, right: CGFloat(insetAmount))
//        let isRTL = MOLHLanguage.isRTLLanguage()
//        if isRTL {
//            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(insetAmount), bottom: 0, right: -CGFloat(insetAmount))
//            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -CGFloat(insetAmount), bottom: 0, right: CGFloat(insetAmount))
//            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: -CGFloat(insetAmount), bottom: 0, right: -CGFloat(insetAmount))
//        } else {
//            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -CGFloat(insetAmount), bottom: 0, right: CGFloat(insetAmount))
//            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(insetAmount), bottom: 0, right: -CGFloat(insetAmount))
//            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(insetAmount), bottom: 0, right: CGFloat(insetAmount))
//        }
        
    }
    
    func prettyHareefButton2(radius:Float?){
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 35.0  //1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius == nil ? 24.0 : 15.0
        self.layer.borderColor = UIColor(red: 49/255, green: 176/255, blue: 179/255, alpha: 1).cgColor
        self.layer.borderWidth = 1.0
        
    }
}

extension UIButton {
    func enable() {
        DispatchQueue.main.async {
            self.isEnabled = true
            self.alpha = 1.0
        }
    }

    func disable() {
        DispatchQueue.main.async {
            self.isEnabled = false
            self.alpha = 0.5
        }
    }
}

extension UIButton {
    func roundCornersForSpecificCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
