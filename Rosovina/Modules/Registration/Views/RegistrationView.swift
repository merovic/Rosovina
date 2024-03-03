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
    
    @IBOutlet weak var emailErrorMessage: UILabel!
    
    @IBOutlet weak var firstNameView: UIView! {
        didSet {
            firstNameView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var firstNameErrorMessage: UILabel!
    
    @IBOutlet weak var lastNameView: UIView! {
        didSet {
            lastNameView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var lastNameErrorMessage: UILabel!
    
    @IBOutlet weak var phoneView: UIView! {
        didSet {
            phoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var phoneErrorMessage: UILabel!
    
    
    @IBOutlet weak var passwordView: UIView! {
        didSet {
            passwordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordErrorMessage: UILabel!
    
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
            createButton.disable()
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
        
        viewModel.$passwordEyeOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSecureTextEntry, on: passwordTextField)
            .store(in: &bindings)
        
        passwordGest.tapPublisher
            .sink(receiveValue:{_ in
                self.passwordEye.image = UIImage(systemName: self.viewModel.passwordEyeOn ? "eye.slash.fill" : "eye.fill")
                self.viewModel.switchPasswordEye()
            })
            .store(in: &bindings)
        
        firstNameTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .name)
            .assign(to: \.firstNameValidationState, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$firstNameValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.firstNameErrorMessage.isHidden = false
                    self.firstNameErrorMessage.text = error.description
                    self.firstNameView.roundedRedHareefView()
                default:
                    self.firstNameErrorMessage.isHidden = true
                    self.firstNameErrorMessage.text = ""
                    self.firstNameView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    state,
                    viewModel.lastNameValidationState,
                    viewModel.emailValidationState,
                    viewModel.passwordValidationState,
                    viewModel.phoneValidationState
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? createButton.enable() : createButton.disable()
            }
            .store(in: &bindings)
        
        lastNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.lastNameText, on: viewModel)
        .store(in: &bindings)
        
        lastNameTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .name)
            .assign(to: \.lastNameValidationState, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$lastNameValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.lastNameErrorMessage.isHidden = false
                    self.lastNameErrorMessage.text = error.description
                    self.lastNameView.roundedRedHareefView()
                default:
                    self.lastNameErrorMessage.isHidden = true
                    self.lastNameErrorMessage.text = ""
                    self.lastNameView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    viewModel.firstNameValidationState,
                    state,
                    viewModel.emailValidationState,
                    viewModel.passwordValidationState,
                    viewModel.phoneValidationState
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? createButton.enable() : createButton.disable()
            }
            .store(in: &bindings)
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.emailText, on: viewModel)
        .store(in: &bindings)
        
        emailTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .email)
            .assign(to: \.emailValidationState, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$emailValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.emailErrorMessage.isHidden = false
                    self.emailErrorMessage.text = error.description
                    self.emailView.roundedRedHareefView()
                default:
                    self.emailErrorMessage.isHidden = true
                    self.emailErrorMessage.text = ""
                    self.emailView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    viewModel.firstNameValidationState,
                    viewModel.lastNameValidationState,
                    state,
                    viewModel.passwordValidationState,
                    viewModel.phoneValidationState
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? createButton.enable() : createButton.disable()
            }
            .store(in: &bindings)
        
        phoneTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneText, on: viewModel)
        .store(in: &bindings)
        
        phoneTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .phone(country: .egypt))
            .assign(to: \.phoneValidationState, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$phoneValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.phoneErrorMessage.isHidden = false
                    self.phoneErrorMessage.text = error.description
                    self.phoneView.roundedRedHareefView()
                default:
                    self.phoneErrorMessage.isHidden = true
                    self.phoneErrorMessage.text = ""
                    self.phoneView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    viewModel.firstNameValidationState,
                    viewModel.lastNameValidationState,
                    viewModel.emailValidationState,
                    viewModel.passwordValidationState,
                    state
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? createButton.enable() : createButton.disable()
            }
            .store(in: &bindings)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordText, on: viewModel)
        .store(in: &bindings)
        
        passwordTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .password)
            .assign(to: \.passwordValidationState, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$passwordValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.passwordErrorMessage.isHidden = false
                    self.passwordErrorMessage.text = error.description
                    self.passwordView.roundedRedHareefView()
                default:
                    self.passwordErrorMessage.isHidden = true
                    self.passwordErrorMessage.text = ""
                    self.passwordView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    viewModel.firstNameValidationState,
                    viewModel.lastNameValidationState,
                    viewModel.emailValidationState,
                    state,
                    viewModel.phoneValidationState
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? createButton.enable() : createButton.disable()
            }
            .store(in: &bindings)
        
        createButton.tapPublisher
            .sink { _ in
                //self.viewModel.checkPhone()
                self.viewModel.register()
            }
            .store(in: &bindings)
        
        viewModel.$otpSentStatus.sink { v in
            if v == .success{
                let nav1 = UINavigationController()
                let vc = DashboardTabBarController()
                nav1.isNavigationBarHidden = true
                nav1.viewControllers = [vc]
                nav1.modalPresentationStyle = .fullScreen
                self.present(nav1, animated: true)
                
//                let newViewController = VerificationViewController()
//                newViewController.viewModel = VerificationViewModel(phoneText: self.viewModel.checkForPhone(phone: self.viewModel.phoneText, code: self.viewModel.phoneCode), phoneCode: self.viewModel.phoneCode, nameText: self.viewModel.firstNameText + " " + self.viewModel.lastNameText, emailText: self.viewModel.emailText, passwordText: self.viewModel.passwordText)
//                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if v == .failed{
                Alert.show("Registration Error", message: "Something Error Happined Please Try Again", context: self)
            }else if v == .error{
                Alert.show("Registration Error", message: "Phone has been taken", context: self)
            }
        }.store(in: &bindings)
        
    }

}
