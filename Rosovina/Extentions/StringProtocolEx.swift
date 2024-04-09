//
//  StringProtocolEx.swift
//  Hareef-Captain
//
//  Created by Amir Ahmed on 02/03/2024.
//

import Foundation
import UIKit

extension StringProtocol {
    func startcased() -> String {
        components(separatedBy: " ")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}

public extension UILabel {
    @IBInspectable var localizeKey: String? {
        get {
            return text
        }
        set {
            text = NSLocalizedString(newValue ?? "", comment: "")
        }
    }
}

public extension UIButton {
    @IBInspectable var localizeKey: String? {
        get {
            return titleLabel?.text
        }
        set {
            setTitle(NSLocalizedString(newValue ?? "", comment: ""), for: .normal)
        }
    }
}

public extension UITextField {
    @IBInspectable var localizeKey: String? {
        get {
            return placeholder
        }
        set {
            placeholder = NSLocalizedString(newValue ?? "", comment: "")
        }
    }
}
