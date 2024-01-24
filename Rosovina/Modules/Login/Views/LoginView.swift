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
    
    @IBOutlet weak var countryPickerView: UIView!
    
    @IBOutlet weak var emailView: UIView! {
        didSet {
            emailView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView! {
        didSet {
            passwordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var passwordIncorrectLabel: UILabel!
    
    @IBOutlet weak var continueLabel: UILabel!
    
    @IBOutlet weak var socialStack: UIStackView!
    
    @IBOutlet weak var getStartedButton: UIButton! {
        didSet {
            getStartedButton.prettyHareefButton(radius: 16)
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
        
        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneText, on: viewModel)
        .store(in: &bindings)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordText, on: viewModel)
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
        
//        backButton.tapPublisher
//            .sink { _ in
//                self.dismiss(animated: true)
//            }
//            .store(in: &bindings)
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel.phoneCode = code
        }.store(in: &bindings)
        
        viewModel.$loginStatus.sink { v in
            if v == .success{
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
            case .keyboardWillHide:
                self.signupStack.isHidden = false
                self.continueLabel.isHidden = false
                self.socialStack.isHidden = false
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
