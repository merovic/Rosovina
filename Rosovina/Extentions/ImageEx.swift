//
//  ImageExt.swift
//  Hareef
//
//  Created by PaySky106 on 24/05/2023.
//

import UIKit

extension UIImageView {
    func makeRounded() {
        layer.masksToBounds = false
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    func makeRoundedWithBorder() {
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func makeCircularRounded() {
        //layer.borderWidth = 1
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
