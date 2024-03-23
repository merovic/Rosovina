//
//  ForgetPasswordView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import Combine
import CombineCocoa

class ForgetPasswordView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: CreatePasswordViewModel!
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var newPasswordView: UIView! {
        didSet {
            newPasswordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordErrorMessage: UILabel!
    
    @IBOutlet weak var retypeView: UIView! {
        didSet {
            retypeView.roundedGrayHareefView()
        }
    }
    
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
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var confirmPasswordGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var confirmPasswordEye: UIImageView! {
        didSet {
            confirmPasswordEye.isUserInteractionEnabled = true
            confirmPasswordEye.addGestureRecognizer(confirmPasswordGest)
        }
    }
    
    @IBOutlet weak var retypeErrorMessage: UILabel!
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.prettyHareefButton(radius: 16)
            doneButton.disable()
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
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordText, on: viewModel)
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
                    self.newPasswordView.roundedRedHareefView()
                default:
                    self.passwordErrorMessage.isHidden = true
                    self.passwordErrorMessage.text = ""
                    self.newPasswordView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    state,
                    viewModel.confirmValidationState,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? doneButton.enable() : doneButton.disable()
            }
            .store(in: &bindings)
        
        viewModel.$passwordEyeOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSecureTextEntry, on: passwordTextField)
            .store(in: &bindings)
        
        viewModel.$confirmEyeOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSecureTextEntry, on: confirmPasswordTextField)
            .store(in: &bindings)
        
        confirmPasswordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.confirmText, on: viewModel)
        .store(in: &bindings)
        
        confirmPasswordTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .password)
            .assign(to: \.confirmValidationState, on: viewModel)
        .store(in: &bindings)
        
        viewModel.$confirmValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.retypeErrorMessage.isHidden = false
                    self.retypeErrorMessage.text = error.description
                    self.retypeView.roundedRedHareefView()
                default:
                    self.retypeErrorMessage.isHidden = true
                    self.retypeErrorMessage.text = ""
                    self.retypeView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    state,
                    viewModel.passwordValidationState,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? doneButton.enable() : doneButton.disable()
            }
            .store(in: &bindings)
        
        passwordGest.tapPublisher
            .sink(receiveValue:{_ in
                self.passwordEye.image = UIImage(systemName: self.viewModel.passwordEyeOn ? "eye.slash.fill" : "eye.fill")
                self.viewModel.switchPasswordEye()
            })
            .store(in: &bindings)
        
        confirmPasswordGest.tapPublisher
            .sink(receiveValue:{_ in
                self.confirmPasswordEye.image = UIImage(systemName: self.viewModel.confirmEyeOn ? "eye.slash.fill" : "eye.fill")
                self.viewModel.switchConfirmEye()
            })
            .store(in: &bindings)
        
        doneButton.tapPublisher
            .sink { _ in
                self.viewModel.resetPassword()
            }
            .store(in: &bindings)
        
        viewModel.$resetStatus.sink { v in
            if v == .success{
                self.viewModel.login()
            }else if v == .failed{
                Alert.show("Forget Password Error", message: "Please Try Again", context: self)
            }
        }.store(in: &bindings)
        
        viewModel.$loginStatus.sink { v in
            if v == .success{
                let nav1 = UINavigationController()
                let vc = DashboardTabBarController()
                nav1.isNavigationBarHidden = true
                nav1.viewControllers = [vc]
                nav1.modalPresentationStyle = .fullScreen
                self.present(nav1, animated: true)
            }else if v == .failed{
                Alert.show("Forget Password Error", message: "Please Try Again", context: self)
            }
        }.store(in: &bindings)
    }

}
