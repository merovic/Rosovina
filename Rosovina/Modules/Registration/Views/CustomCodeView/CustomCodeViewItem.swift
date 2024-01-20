//
//  CustomCodeViewItem.swift
//  SwiftyCodeView
//
//  Created by Artur Mkrtchyan on 6/30/18.
//  Copyright © 2018 arturdev. All rights reserved.
//

import UIKit
import SwiftyCodeView

class CustomCodeItemView: SwiftyCodeItemView {
        
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var itemHeight: NSLayoutConstraint!
    @IBOutlet weak var itemWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        isUserInteractionEnabled = false
        textField.text = ""
        borderView.layer.cornerRadius = 12
        borderView.layer.borderWidth = 0
        borderView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
    }
}
