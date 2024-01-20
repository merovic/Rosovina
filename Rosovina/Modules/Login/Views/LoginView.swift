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
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var signupStack: UIStackView!
    
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
        
        viewModel.$loginStatus.sink { v in
            if v == .success{
                self.passwordIncorrectLabel.isHidden = true
                let newViewController = DashboardTabBarController()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if v == .failed{
                self.passwordIncorrectLabel.isHidden = false
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
    
    @IBAction func signUpClicked(_ sender: Any) {
        let newViewController = RegistrationView()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func forgetPasswordClicked(_ sender: Any) {
        let newViewController = PhoneNumberView()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func getStartedClicked(_ sender: Any) {
        self.viewModel.login()
    }
}
