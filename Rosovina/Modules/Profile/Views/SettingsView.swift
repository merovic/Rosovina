//
//  SettingsView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit

class SettingsView: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var languageView: UIView! {
        didSet {
            languageView.roundedGrayHareefView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
