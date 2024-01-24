//
//  RegistrationView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import Combine
import CombineCocoa

class RegistrationView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: RegistrationViewModel = RegistrationViewModel()
    
    var countryPickerViewModel: CountryPickerViewModel = CountryPickerViewModel()
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var countryPickerView: UIView!

    @IBOutlet weak var emailView: UIView! {
        didSet {
            emailView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var firstNameView: UIView! {
        didSet {
            firstNameView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameView: UIView! {
        didSet {
            lastNameView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneView: UIView! {
        didSet {
            phoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView! {
        didSet {
            passwordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var passwordGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var passwordEye: UIImageView! {
        didSet {
            passwordEye.isUserInteractionEnabled = true
            passwordEye.addGestureRecognizer(passwordGest)
        }
    }
    
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            createButton.prettyHareefButton(radius: 16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.countryPickerView.EmbedSwiftUIView(view: CountryPicker(viewModel: countryPickerViewModel), parent: self)
    }

    func BindViews(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel.phoneCode = code
        }.store(in: &bindings)
        
        firstNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.firstNameText, on: viewModel)
        .store(in: &bindings)
        
        lastNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastNameText, on: viewModel)
        .store(in: &bindings)
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.emailText, on: viewModel)
        .store(in: &bindings)
        
        phoneTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneText, on: viewModel)
        .store(in: &bindings)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordText, on: viewModel)
        .store(in: &bindings)
        
        createButton.tapPublisher
            .sink { _ in
                //self.viewModel.sendOTP()
                if self.viewModel.canContinue {
                    self.viewModel.otpSentStatus = .success
                }else{
                    self.viewModel.otpSentStatus = .failed
                }
                
            }
            .store(in: &bindings)
        
        viewModel.$otpSentStatus.sink { v in
            if v == .success{
                let newViewController = VerificationViewController()
                newViewController.viewModel = VerificationViewModel(phoneText: self.viewModel.phoneText, nameText: self.viewModel.firstNameText + " " + self.viewModel.lastNameText, emailText: self.viewModel.emailText, passwordText: self.viewModel.passwordText)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if v == .failed{
                Alert.show("Registration Error", message: "Something Error Happined Please Try Again", context: self)
            }
        }.store(in: &bindings)
        
    }

}
