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
    
    @IBOutlet weak var defaultSwitch: UISwitch!
    
    @IBOutlet weak var addNewButton: UIButton! {
        didSet {
            addNewButton.prettyHareefButton(radius: 16)
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
        
        self.dismiss(animated: true)
        //navigationController?.popToRootViewController(animated: true)
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
                self.viewModel?.addAddress()
            }
            .store(in: &bindings)
        
        viewModel!.$addedAddress.sink { response in
            if response != nil{
                self.updateValueAndNavigateBack(address: response!)
//                self.delegate.didLocationSelected(location: response!)
//                self.navigationController?.popViewController(animated: true)
            }
        }.store(in: &bindings)
    }

}

extension Notification.Name {
    static let didUpdateValue = Notification.Name("didUpdateValue")
}
