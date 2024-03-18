//
//  ViewEx.swift
//  Abshare
//
//  Created by Apple on 06/10/2021.
//

import UIKit

extension UIView{
    
    func roundedMinorHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 6
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.1897802949, green: 0.6920717359, blue: 0.7039652467, alpha: 1)
    }
    
    func roundedHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.1897802949, green: 0.6920717359, blue: 0.7039652467, alpha: 1)
    }
    
    func roundedGrayHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.9387457371, green: 0.9387457371, blue: 0.9387457371, alpha: 1)
    }
    
    func roundedRedHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    }
    
    func roundedBlackHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func roundedLightGrayHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8107264638, green: 0.8107264638, blue: 0.8107264638, alpha: 1)
    }
    
    func roundedWhiteHareefView(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func roundedExtraHareefView(){
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0.1897802949, green: 0.6920717359, blue: 0.7039652467, alpha: 1)
    }
    
    func roundedRosovinaLight(){
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.init(named: "LightGray")
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func roundedRosovinaDark(){
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.init(named: "OnionColor")
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    }
    
    func rounded(){
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
    }
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


extension UIImageView {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
        self.clipsToBounds = false
    }
}
