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

    @IBOutlet weak var newPasswordView: UIView! {
        didSet {
            newPasswordView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
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
        
        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordText, on: viewModel)
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
