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
    
    @IBOutlet weak var addAddressView: UIView! {
        didSet {
            addAddressView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var addAddressTextField: UITextField!
    
    @IBOutlet weak var addressContentView: UIView! {
        didSet {
            addressContentView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var addressContentTextField: UITextField!
    
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
    
    @IBOutlet weak var postCodeView: UIView! {
        didSet {
            postCodeView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var postCodeTextField: UITextField!
    
    @IBOutlet weak var defaultSwitch: UISwitch! {
        didSet {
            defaultSwitch.isOn = viewModel!.isDefault
        }
    }
    
    @IBOutlet weak var addNewButton: UIButton! {
        didSet {
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
    
    func updateValueAndNavigateBack(address: UserAddress) {
        
        // Post the notification
        NotificationCenter.default.post(name: .didUpdateValue, object: address)
        
        if self.viewModel?.addressToUpdate != nil {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true)
        }
        
    }
    
    func AttachViews() {
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
            self.postCodeTextField.text = self.viewModel?.postalCode
            self.defaultSwitch.isOn = self.viewModel!.isDefault
        }
        
        addAddressTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.addressName, on: viewModel!)
        .store(in: &bindings)
        
        addressContentTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.addressContent, on: viewModel!)
        .store(in: &bindings)
        
        postCodeTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.postalCode, on: viewModel!)
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
        
        viewModel!.$errorMessage.sink { error in
            if error != ""{
                Alert.show("Error Saving an Address", message: error, context: self)
            }
        }.store(in: &bindings)
    }

}

extension Notification.Name {
    static let didUpdateValue = Notification.Name("didUpdateValue")
}
