//
//  LoadingAnimation.swift
//  Wassalny
//
//  Created by Apple on 08/03/2021.
//  Copyright © 2021 amirahmed. All rights reserved.
//

import UIKit
import ProgressHUD

class LoadingAnimation: UIView {
    
    static let instance = LoadingAnimation()
    
    @IBOutlet var parentView: UIView!
    
    var isVisible = false {
        didSet {
            ProgressHUD.colorAnimation = .systemGray2
            ProgressHUD.colorProgress = .systemGray2
            if(isVisible){
                UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(parentView)
                ProgressHUD.show()
            }else{
                parentView.removeFromSuperview()
                ProgressHUD.dismiss()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AnimationLoading", owner: self, options: nil)
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
