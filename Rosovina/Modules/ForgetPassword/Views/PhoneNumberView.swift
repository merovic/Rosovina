//
//  PhoneNumberView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 23/12/2023.
//

import UIKit
import Combine
import CombineCocoa

class PhoneNumberView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: PhoneNumberViewModel!
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var phoneView: UIView! {
        didSet {
            phoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.prettyHareefButton(radius: 16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindView()
    }
    
    func BindView(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneText, on: viewModel)
        .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        doneButton.tapPublisher
            .sink { _ in
                self.viewModel.sendOTP()
            }
            .store(in: &bindings)
        
        viewModel.$otpSentStatus.sink { v in
            if v == .success{
//                let newViewController = MainTabView(nibName: "MainTabView", bundle: nil)
//                newViewController.modalPresentationStyle = .fullScreen
//                self.present(newViewController, animated: true, completion: nil)
            }else if v == .failed{
                //Alert.sawaShow(imageName: "warning", title: "Login Failed", subtitle: "Password is Incorrect", buttonTitle: "Ok", context: self)
            }
        }.store(in: &bindings)
        
    }

}
