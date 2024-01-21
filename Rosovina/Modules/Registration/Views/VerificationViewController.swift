//
//  VerificationViewController.swift
//  Rosovina
//
//  Created by Amir Ahmed on 20/12/2023.
//

import UIKit
import Combine
import CombineCocoa
import SwiftyCodeView

class VerificationViewController: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: VerificationViewModel!
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var phoneNumberText: UILabel!
    
    @IBOutlet weak var otpView: CustomCodeView!
    
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            continueButton.prettyHareefButton(radius: 16)
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.delegate = self
        BindViews()
    }
    
    func BindViews(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        phoneNumberText.text = "We texted you on " + viewModel.phoneText
        
        continueButton.tapPublisher
            .sink { _ in
                //self.viewModel.register()
                self.viewModel.otpCheck()
            }
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        viewModel.$registrationStatus.sink { v in
            if v == .success{
                let newViewController = DashboardTabBarController()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if v == .failed{
                Alert.show("Registration Error", message: self.viewModel.errorMessage, context: self)
            }
        }.store(in: &bindings)
    }

}

extension VerificationViewController: SwiftyCodeViewDelegate {
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        self.viewModel.codeText = code
        return true
    }
}