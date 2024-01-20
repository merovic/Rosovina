//
//  ViewFragmentation.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 14/07/2022.
//

import Foundation
import UIKit
import SwiftUI

class ViewFragmentation {
    
    static func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
}

extension UIView{
    func EmbedSwiftUIView(view: any View, parent: UIViewController){
        let newViewController = UIHostingController(rootView: AnyView(view))
        newViewController.view.backgroundColor = UIColor.clear
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        parent.addChild(newViewController)
        ViewFragmentation.addSubview(subView: newViewController.view, toView: self)
    }
}
