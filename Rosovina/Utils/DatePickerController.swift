//
//  DatePickerController.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 14/03/2023.
//

import UIKit

class DatePickerController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var completion: ((String) -> Void)? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeClicker(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-dd"
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
        let strDate = dateFormatter.string(from: datePicker.date)
        
        self.completion?(strDate)
        self.dismiss(animated: true, completion: nil)
    }
    
}

