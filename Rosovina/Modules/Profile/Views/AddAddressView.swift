//
//  AddAddressView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 12/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class AddAddressView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: AddAddressViewModel?
    
    var countryPickerViewModel: CountryPickerViewModel = CountryPickerViewModel()
    
    private let loadingView = LoadingAnimation()
    
    var delegate: SelectLocationDelegate!

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            if self.viewModel?.addressToUpdate != nil {
                titleLabel.text = "Update Address"
            }
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var recipientNameView: UIView! {
        didSet {
            recipientNameView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var recipientNameTextField: UITextField!
    
    @IBOutlet weak var recipientNameErrorMessage: UILabel!
    
    @IBOutlet weak var countryPickerView: UIView!
    
    @IBOutlet weak var phoneView: UIView! {
        didSet {
            phoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var phoneErrorMessage: UILabel!
    
    @IBOutlet weak var addAddressView: UIView! {
        didSet {
            addAddressView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var addAddressTextField: UITextField!
    
    @IBOutlet weak var addAddressErrorMessage: UILabel!
    
    @IBOutlet weak var addressContentView: UIView! {
        didSet {
            addressContentView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var addressContentTextField: UITextField!
    
    @IBOutlet weak var addressContentErrorMessage: UILabel!
    
    @IBOutlet weak var countryView: UIView! {
        didSet {
            countryView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var cityView: UIView! {
        didSet {
            cityView.roundedGrayHareefView()
        }
    }
        
    @IBOutlet weak var areaView: UIView! {
        didSet {
            areaView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var defaultSwitch: UISwitch! {
        didSet {
            defaultSwitch.isOn = viewModel!.isDefault
        }
    }
    
    @IBOutlet weak var addNewButton: UIButton! {
        didSet {
            addNewButton.disable()
            addNewButton.prettyHareefButton(radius: 16)
            if self.viewModel?.addressToUpdate != nil {
                addNewButton.setTitle("Update Address", for: .normal)
            }
        }
    }
    
    
    @IBOutlet weak var deleteAddress: UIButton! {
        didSet {
            deleteAddress.prettyHareefButton(radius: 16)
            if self.viewModel?.addressToUpdate == nil {
                deleteAddress.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func updateValueAndNavigateBack(address: UserAddress?) {
        // Post the notification
        NotificationCenter.default.post(name: .didUpdateValue, object: address)
        
        if self.viewModel?.addressToUpdate != nil {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true)
        }
        
    }
    
    func AttachViews() {
        self.countryPickerView.EmbedSwiftUIView(view: CountryPicker(viewModel: countryPickerViewModel), parent: self)
        self.countryView.EmbedSwiftUIView(view: Dropdown(selection: .countries, placeholder: "Select Country", viewModel: self.viewModel!), parent: self)
        self.cityView.EmbedSwiftUIView(view: Dropdown(selection: .cities, placeholder: "Select City", viewModel: self.viewModel!), parent: self)
        self.areaView.EmbedSwiftUIView(view: Dropdown(selection: .areas, placeholder: "Select Area", viewModel: self.viewModel!), parent: self)
    }
    
    func BindViews(){
        
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addAddressTextField.text = self.viewModel?.addressName
            self.addressContentTextField.text = self.viewModel?.addressContent
            self.defaultSwitch.isOn = self.viewModel!.isDefault
        }
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel?.recipientPhoneCode = code
            self.viewModel?.recipientPhoneText = ""
            self.phoneTextField.text = ""
            self.viewModel?.recipientPhoneValidationState = .idle
            self.phoneErrorMessage.text = ""
            
            self.viewModel?.egyptValidationSubscription?.cancel()
            self.viewModel?.saudiArabiaValidationSubscription?.cancel()
            
            if code == "+966"{
                self.subscripeSaudiArabia()
            }else{
                self.subscripeEgypt()
            }
        }.store(in: &bindings)
        
        recipientNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.recipientNameText, on: viewModel!)
        .store(in: &bindings)
        
        recipientNameTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .simpleName)
            .assign(to: \.recipientNameValidationState, on: viewModel!)
        .store(in: &bindings)
        
        viewModel!.$recipientNameValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.recipientNameErrorMessage.isHidden = false
                    self.recipientNameErrorMessage.text = error.description
                    self.recipientNameView.roundedRedHareefView()
                default:
                    self.recipientNameErrorMessage.isHidden = true
                    self.recipientNameErrorMessage.text = ""
                    self.recipientNameView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    state,
                    viewModel!.recipientPhoneValidationState,
                    viewModel!.addressNameValidationState,
                    viewModel!.addressContentValidationState,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? addNewButton.enable() : addNewButton.disable()
            }
            .store(in: &bindings)
        
        
        phoneTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.recipientPhoneText, on: viewModel!)
        .store(in: &bindings)
        
        self.subscripeSaudiArabia()
        
        viewModel!.$recipientPhoneValidationState
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
                    viewModel!.recipientNameValidationState,
                    state,
                    viewModel!.addressNameValidationState,
                    viewModel!.addressContentValidationState,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? addNewButton.enable() : addNewButton.disable()
            }
            .store(in: &bindings)
        
        addAddressTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.addressName, on: viewModel!)
        .store(in: &bindings)
        
        addAddressTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .simpleName)
            .assign(to: \.addressNameValidationState, on: viewModel!)
        .store(in: &bindings)
        
        viewModel!.$addressNameValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.addAddressErrorMessage.isHidden = false
                    self.addAddressErrorMessage.text = error.description
                    self.addAddressView.roundedRedHareefView()
                default:
                    self.addAddressErrorMessage.isHidden = true
                    self.phoneErrorMessage.text = ""
                    self.addAddressView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    viewModel!.recipientNameValidationState,
                    viewModel!.recipientPhoneValidationState,
                    state,
                    viewModel!.addressContentValidationState,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? addNewButton.enable() : addNewButton.disable()
            }
            .store(in: &bindings)
        
        addressContentTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.addressContent, on: viewModel!)
        .store(in: &bindings)
        
        addressContentTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .simpleName)
            .assign(to: \.addressContentValidationState, on: viewModel!)
        .store(in: &bindings)
        
        viewModel!.$addressContentValidationState
            .sink { [self] state in
                switch state {
                case .error(let error):
                    self.addressContentErrorMessage.isHidden = false
                    self.addressContentErrorMessage.text = error.description
                    self.addressContentView.roundedRedHareefView()
                default:
                    self.addressContentErrorMessage.isHidden = true
                    self.addressContentErrorMessage.text = ""
                    self.addressContentView.roundedGrayHareefView()
                }
                
                let validationStates = [
                    viewModel!.recipientNameValidationState,
                    viewModel!.recipientPhoneValidationState,
                    viewModel!.addressNameValidationState,
                    state,
                ]
                
                validationStates.allSatisfy({ $0 == .valid }) ? addNewButton.enable() : addNewButton.disable()
            }
            .store(in: &bindings)
        
        defaultSwitch.isOnPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isDefault, on: viewModel!)
        .store(in: &bindings)
        
        addNewButton.tapPublisher
            .sink { _ in
                if self.viewModel?.addressToUpdate != nil{
                    self.viewModel?.updateAddress()
                }else{
                    self.viewModel?.addAddress()
                }
            }
            .store(in: &bindings)
        
        deleteAddress.tapPublisher
            .sink { _ in
                self.viewModel?.deleteAddress()
            }
            .store(in: &bindings)
        
        viewModel!.$addedAddress.sink { response in
            if response != nil{
                self.updateValueAndNavigateBack(address: response!)
            }
        }.store(in: &bindings)
        
        viewModel!.$addressDeleted.sink { state in
            if state {
                self.updateValueAndNavigateBack(address: nil)
            }
        }.store(in: &bindings)
        
        viewModel!.$unauthenticated.sink { state in
            if state {
                LoginDataService.shared.setLogout()
                let newViewController = LoginView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel!.$errorMessage.sink { error in
            if error != ""{
                Alert.show("Error Saving an Address", message: error, context: self)
            }
        }.store(in: &bindings)
    }
    
    func subscripeEgypt(){
        viewModel!.egyptValidationSubscription = phoneTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .phone(country: .egypt))
            .assign(to: \.recipientPhoneValidationState, on: viewModel!)
    }
    
    func subscripeSaudiArabia(){
        viewModel!.saudiArabiaValidationSubscription = phoneTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .phone(country: .saudiArabia))
            .assign(to: \.recipientPhoneValidationState, on: viewModel!)
    }

}

extension Notification.Name {
    static let didUpdateValue = Notification.Name("didUpdateValue")
}
