//
//  LongTextView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 09/02/2024.
//

import UIKit

class LongTextView: UIViewController {

    var titleText: String?
    var textContent: String?
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = textContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
