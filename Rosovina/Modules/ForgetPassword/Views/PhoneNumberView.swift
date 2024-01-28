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
    
    @IBOutlet weak var countryPickerView: UIView!
    
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
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel.phoneCode = code
        }.store(in: &bindings)
        
        doneButton.tapPublisher
            .sink { _ in
                if !self.viewModel.phoneText.isEmpty && self.viewModel.phoneText.isValidPhone() {
                    self.viewModel.otpSentStatus = .success
                }else{
                    self.viewModel.otpSentStatus = .failed
                }
                
                //self.viewModel.sendOTP()
            }
            .store(in: &bindings)
        
        viewModel.$otpSentStatus.sink { v in
            if v == .success{
                let newViewController = VerificationViewController()
                newViewController.viewModel = VerificationViewModel(phoneText: self.viewModel.checkForPhone(phone: self.viewModel.phoneText, code: self.viewModel.phoneCode), isResetPassword: true)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }else if v == .failed{
                Alert.show("Reset Failed", message: "Please Try Again", context: self)
            }
        }.store(in: &bindings)
        
    }

}
