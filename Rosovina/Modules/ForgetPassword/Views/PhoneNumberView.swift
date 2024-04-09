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
    
    var countryPickerViewModel: CountryPickerViewModel = CountryPickerViewModel()
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var typeSegmentation: UISegmentedControl! {
        didSet {
            typeSegmentation.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            typeSegmentation.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
            typeSegmentation.setTitle("phone".localized, forSegmentAt: 0)
            typeSegmentation.setTitle("email".localized, forSegmentAt: 1)
        }
    }
    
    @IBOutlet weak var emailContainer: UIView!
    
    @IBOutlet weak var emailView: UIView! {
        didSet {
            emailView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailErrorMessage: UILabel!
    
    @IBOutlet weak var phoneContainer: UIView!
    
    @IBOutlet weak var countryPickerView: UIView!
    
    @IBOutlet weak var phoneView: UIView! {
        didSet {
            phoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var phoneErrorMessage: UILabel!
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.prettyHareefButton(radius: 16)
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
        
        phoneNumberTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.phoneText, on: viewModel)
        .store(in: &bindings)
        
        self.subscripeSaudiArabia()
        
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
                    state
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? doneButton.enable() : doneButton.disable()
            }
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel.phoneCode = code
            self.viewModel.phoneText = ""
            self.phoneNumberTextField.text = ""
            self.viewModel.phoneValidationState = .idle
            self.phoneErrorMessage.text = ""
            
            self.viewModel.egyptValidationSubscription?.cancel()
            self.viewModel.saudiArabiaValidationSubscription?.cancel()
            
            if code == "+966"{
                self.subscripeSaudiArabia()
            }else{
                self.subscripeEgypt()
            }
        }.store(in: &bindings)
        
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
                    state
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? doneButton.enable() : doneButton.disable()
            }
            .store(in: &bindings)
        
//        typeSegmentation.selectedSegmentIndexPublisher
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.selectedType, on: viewModel)
//        .store(in: &bindings)
        
        viewModel.$selectedType.sink { selection in
            if selection == 0 {
                self.phoneContainer.isHidden = false
                self.emailContainer.isHidden = true
                
                self.viewModel.emailText = ""
                self.viewModel.phoneText = ""
                
                self.emailTextField.text = ""
                self.phoneNumberTextField.text = ""
                
                self.emailErrorMessage.text = ""
                self.phoneErrorMessage.text = ""
                
                self.emailErrorMessage.isHidden = true
                self.phoneErrorMessage.isHidden = true
                
                self.viewModel.phoneValidationState = .idle
                self.viewModel.emailValidationState = .idle
            }else{
                self.phoneContainer.isHidden = true
                self.emailContainer.isHidden = false
                
                self.viewModel.emailText = ""
                self.viewModel.phoneText = ""
                
                self.emailTextField.text = ""
                self.phoneNumberTextField.text = ""
                
                self.emailErrorMessage.text = ""
                self.phoneErrorMessage.text = ""
                
                self.emailErrorMessage.isHidden = true
                self.phoneErrorMessage.isHidden = true
                
                self.viewModel.phoneValidationState = .idle
                self.viewModel.emailValidationState = .idle
            }
        }.store(in: &bindings)
        
        doneButton.tapPublisher
            .sink { _ in
                if self.viewModel.selectedType == 0 {
                    if !self.viewModel.phoneText.isEmpty && self.viewModel.phoneText.isValidPhone(forCountry: .egypt) {
                        self.viewModel.sendOTP()
                    }else{
                        self.viewModel.otpSentStatus = .failed
                    }
                }else{
                    if !self.viewModel.emailText.isEmpty && self.viewModel.emailText.isValidEmail() {
                        self.viewModel.retriveToken()
                    }else{
                        self.viewModel.otpSentStatus = .failed
                    }
                }
                
            }
            .store(in: &bindings)
        
        viewModel.$otpSentStatus.sink { v in
            if v == .success{
                let newViewController = VerificationViewController()
                newViewController.viewModel = VerificationViewModel(
                    phoneText: self.viewModel.phoneText,
                    phoneCode: self.viewModel.phoneCode,
                    emailText: self.viewModel.emailText,
                    isResetPassword: true,
                    isResetByEmail: self.viewModel.selectedType == 1,
                    tokenResponse: self.viewModel.tokenResponse)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if v == .failed{
                Alert.show("reset_failed".localized, message: "please_try_again".localized, context: self)
            }
        }.store(in: &bindings)
        
    }

    func subscripeEgypt(){
        viewModel.egyptValidationSubscription = phoneNumberTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .phone(country: .egypt))
            .assign(to: \.phoneValidationState, on: viewModel)
    }
    
    func subscripeSaudiArabia(){
        viewModel.saudiArabiaValidationSubscription = phoneNumberTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .phone(country: .saudiArabia))
            .assign(to: \.phoneValidationState, on: viewModel)
    }
}
