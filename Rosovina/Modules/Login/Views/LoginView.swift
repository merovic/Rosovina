//
//  LoginView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import Combine
import CombineCocoa

class LoginView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    var countryPickerViewModel: CountryPickerViewModel = CountryPickerViewModel()
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var signupStack: UIStackView!
    
    @IBOutlet weak var typeSegmentation: UISegmentedControl! {
        didSet {
            typeSegmentation.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            typeSegmentation.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        }
    }
    
    @IBOutlet weak var countryPickerView: UIView!
    
    @IBOutlet weak var emailContainer: UIView!
    
    @IBOutlet weak var emailView: UIView! {
        didSet {
            emailView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailErrorText: UILabel!
    
    @IBOutlet weak var phoneContainer: UIView!
    
    @IBOutlet weak var phoneView: UIView! {
        didSet {
            phoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var phoneErrorText: UILabel!
    
    @IBOutlet weak var passwordView: UIView! {
        didSet {
            passwordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var passwordErrorText: UILabel!
    
    @IBOutlet weak var passwordIncorrectLabel: UILabel!
    
    @IBOutlet weak var continueLabel: UILabel!
    
    @IBOutlet weak var socialStack: UIStackView!
    
    @IBOutlet weak var getStartedButton: UIButton! {
        didSet {
            getStartedButton.prettyHareefButton(radius: 16)
            getStartedButton.disable()
        }
    }
    
    private var keyboardHelper: KeyboardHelper?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindView()
        AttachViews()
    }
    
    func AttachViews() {
        self.countryPickerView.EmbedSwiftUIView(view: CountryPicker(viewModel: countryPickerViewModel), parent: self)
    }
    
    func BindView(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
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
                    self.phoneErrorText.isHidden = false
                    self.phoneErrorText.text = error.description
                    self.phoneView.roundedRedHareefView()
                default:
                    self.phoneErrorText.isHidden = true
                    self.phoneErrorText.text = ""
                    self.phoneView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    state,
                    viewModel.passwordValidationState,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? getStartedButton.enable() : getStartedButton.disable()
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
                    self.emailErrorText.isHidden = false
                    self.emailErrorText.text = error.description
                    self.emailView.roundedRedHareefView()
                default:
                    self.emailErrorText.isHidden = true
                    self.emailErrorText.text = ""
                    self.emailView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    state,
                    viewModel.passwordValidationState,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? getStartedButton.enable() : getStartedButton.disable()
            }
            .store(in: &bindings)
        
        typeSegmentation.selectedSegmentIndexPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedType, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$selectedType.sink { selection in
            if selection == 0 {
                self.phoneContainer.isHidden = false
                self.emailContainer.isHidden = true
                
                self.viewModel.emailText = ""
                self.viewModel.phoneText = ""
                
                self.emailTextField.text = ""
                self.phoneTextField.text = ""
                
                self.emailErrorText.text = ""
                self.phoneErrorText.text = ""
                
                self.emailErrorText.isHidden = true
                self.phoneErrorText.isHidden = true
                
                self.viewModel.phoneValidationState = .idle
                self.viewModel.emailValidationState = .idle
            }else{
                self.phoneContainer.isHidden = true
                self.emailContainer.isHidden = false
                
                self.viewModel.emailText = ""
                self.viewModel.phoneText = ""
                
                self.emailTextField.text = ""
                self.phoneTextField.text = ""
                
                self.emailErrorText.text = ""
                self.phoneErrorText.text = ""
                
                self.emailErrorText.isHidden = true
                self.phoneErrorText.isHidden = true
                
                self.viewModel.phoneValidationState = .idle
                self.viewModel.emailValidationState = .idle
            }
        }.store(in: &bindings)
        
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
                    self.passwordErrorText.isHidden = false
                    self.passwordErrorText.text = error.description
                    self.passwordView.roundedRedHareefView()
                default:
                    self.passwordErrorText.isHidden = true
                    self.passwordErrorText.text = ""
                    self.passwordView.roundedGrayHareefView()
                }
                
                var validationStates: [ValidationState] = []
                
                if self.viewModel.selectedType == 0 {
                    validationStates = [
                        state,
                        viewModel.phoneValidationState,
                    ]
                }else{
                    validationStates = [
                        state,
                        viewModel.emailValidationState,
                    ]
                }
                
                validationStates.allSatisfy({ $0 == .valid }) ? getStartedButton.enable() : getStartedButton.disable()
            }
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
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel.phoneCode = code
        }.store(in: &bindings)
        
        viewModel.$loginStatus.sink { v in
            if v == .success{
                HapticFeedBackEngine.shared.successFeedback()
                self.passwordIncorrectLabel.isHidden = true
                let nav1 = UINavigationController()
                let vc = DashboardTabBarController()
                nav1.isNavigationBarHidden = true
                nav1.viewControllers = [vc]
                nav1.modalPresentationStyle = .fullScreen
                self.present(nav1, animated: true)
            }else if v == .failed{
                self.passwordIncorrectLabel.isHidden = false
            }else if v == .error{
                Alert.show("Login Failed", message: "Check your Inputs First", context: self)
            }
        }.store(in: &bindings)
        
        keyboardHelper = KeyboardHelper {animation, keyboardFrame, duration in
            switch animation {
            case .keyboardWillShow:
                self.signupStack.isHidden = true
                self.continueLabel.isHidden = true
                self.socialStack.isHidden = true
                self.typeSegmentation.isHidden = true
            case .keyboardWillHide:
                self.signupStack.isHidden = false
                self.continueLabel.isHidden = false
                self.socialStack.isHidden = false
                self.typeSegmentation.isHidden = false
            }
        }
        
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        let nav1 = UINavigationController()
        let vc = DashboardTabBarController()
        nav1.isNavigationBarHidden = true
        nav1.viewControllers = [vc]
        nav1.modalPresentationStyle = .fullScreen
        self.present(nav1, animated: true)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        let newViewController = RegistrationView()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func forgetPasswordClicked(_ sender: Any) {
        let newViewController = PhoneNumberView()
        newViewController.viewModel = PhoneNumberViewModel()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func getStartedClicked(_ sender: Any) {
        self.viewModel.login()
    }
}
