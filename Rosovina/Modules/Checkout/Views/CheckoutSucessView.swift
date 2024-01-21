//
//  CheckoutSucessView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit

class CheckoutSucessView: UIViewController {

    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            continueButton.prettyHareefButton(radius: 16)
        }
    }
    
    @IBOutlet weak var trackButton: UIButton! {
        didSet {
            trackButton.prettyHareefButton(radius: 16)
        }
    }
    
    var orderID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        let newViewController = DashboardTabBarController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func trackClicked(_ sender: Any) {
        let newViewController = OrderTrackingView()
        newViewController.viewModel = MyOrderDetailsViewModel(orderID: String(orderID))
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
