//
//  NeedLoginView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 19/01/2024.
//

import UIKit

class NeedLoginView: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.prettyHareefButton(radius: 16)
        }
    }
    
    var showBackButton: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showBackButton != nil{
            self.backButton.isHidden = false
        }else{
            self.backButton.isHidden = true
        }
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        let newViewController = LoginView()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
