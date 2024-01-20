//
//  RajdhaniFontCustom.swift
//  YallaSuperApp
//
//  Created by Paysky team on 25/05/2022.
//

import SwiftUI
import UIKit

extension Font {
    public static func poppinsFont(size: CGFloat, weight: Font.Weight) -> Font?{
        switch weight {
        case .black:
            return Font.custom("Poppins-Black", size: size)
        case .heavy:
            return Font.custom("Poppins-ExtraBold", size: size)
        case .medium:
            return Font.custom("Poppins-Medium",size: size)
        case .bold:
            return Font.custom("Poppins-Bold", size: size)
        case .regular:
            return Font.custom("Poppins-Regular", size: size)
        case .thin:
            return Font.custom("Poppins-ExtraLight",size: size)
        case .semibold:
            return Font.custom("Poppins-SemiBold", size: size)
        case .light:
            return Font.custom("Poppins-Light",size: size)
        
        default:
            return Font.custom("Poppins-Regular", size: size)
        }
    }

}
