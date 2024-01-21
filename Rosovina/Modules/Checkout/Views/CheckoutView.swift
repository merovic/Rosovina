//
//  CheckoutView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import UIKit
import Combine
import CombineCocoa

class CheckoutView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: CheckoutViewModel?
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backbutton: UIButton!
    
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var addAddressInitButton: UIButton! {
        didSet {
            addAddressInitButton.prettyHareefButton(radius: 16)
        }
    }
    @IBOutlet weak var addressView: UIView! {
        didSet {
            addressView.rounded()
        }
    }
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var selectedAddressName: UILabel!
    @IBOutlet weak var selectedAddressPhone: UILabel!
    @IBOutlet weak var selectedAddressContent: UILabel!
    
    @IBOutlet weak var creditCardView: UIView! {
        didSet {
            creditCardView.rounded()
        }
    }
    @IBOutlet weak var codView: UIView! {
        didSet {
            codView.rounded()
        }
    }
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var serviceFeeLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton! {
        didSet {
            payButton.prettyHareefButton(radius: 16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        // Add observer for the custom notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidUpdateValue(_:)), name: .didUpdateValue, object: nil)
    }
    
    deinit {
        // Remove observer in deinit to avoid memory leaks
        NotificationCenter.default.removeObserver(self, name: .didUpdateValue, object: nil)
    }
    
    // Handler for the custom notification
    @objc func handleDidUpdateValue(_ notification: Notification) {
        if let updatedValue = notification.object as? UserAddress {
            // Handle the updated value as needed
            print("Updated value received in FirstViewController: \(updatedValue)")
            self.viewModel?.selectedLocation = updatedValue
            self.viewModel?.updateCart()
        }
    }
    
    func BindViews(){
        
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backbutton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        addAddressButton.tapPublisher
            .sink { _ in
                let newViewController = LocationPickerView()
                
                // Create a new navigation controller for the second view controller
                let navigationController = UINavigationController(rootViewController: newViewController)
                
                // Present the new navigation controller modally
                self.present(navigationController, animated: true, completion: nil)
            }
            .store(in: &bindings)
        
        addAddressInitButton.tapPublisher
            .sink { _ in
                let newViewController = LocationPickerView()
                
                // Create a new navigation controller for the second view controller
                let navigationController = UINavigationController(rootViewController: newViewController)
                
                // Present it in fullscreen
                navigationController.modalPresentationStyle = .fullScreen
                
                // Present the new navigation controller modally
                self.present(navigationController, animated: true, completion: nil)
                
                navigationController.setNavigationBarHidden(true, animated: false)
                
//                let newViewController = AddAddressView()
//                newViewController.viewModel = AddAddressViewModel()
//                newViewController.delegate = self
//                self.navigationController?.pushViewController(newViewController, animated: true)
            }
            .store(in: &bindings)
        
        changeAddressButton.tapPublisher
            .sink { _ in
                let newViewController = SelectAddressView()
                newViewController.delegate = self
                newViewController.modalPresentationStyle = .overCurrentContext
                newViewController.modalTransitionStyle = .crossDissolve
                self.present(newViewController, animated: true)
            }
            .store(in: &bindings)
        
        payButton.tapPublisher
            .sink { _ in
                if self.viewModel?.cartResponse.address != nil{
                    self.viewModel?.createOrder()
                }else{
                    Alert.show("Cant Complete Order", message: "Select a Delivery Address First", context: self)
                }
            }
            .store(in: &bindings)
        
        viewModel!.$cartResponse.sink { response in
            if response.addressID != nil {
                self.addAddressInitButton.isHidden = true
                self.addAddressButton.isHidden = false
                self.addressView.isHidden = false
                
                self.selectedAddressName.text = response.address?.name
                self.selectedAddressContent.text = response.address?.address
                self.selectedAddressPhone.text = response.address?.postalCode
            }else{
                self.addAddressInitButton.isHidden = false
            }
            
            self.subTotalLabel.text = String(response.subTotal) + " " + response.currencyCode
            self.deliveryFeeLabel.text = String(response.deliveryFee) + " " + response.currencyCode
            self.serviceFeeLabel.text = String(response.discountPercentage) + " " + response.currencyCode
            self.totalAmountLabel.text = String(response.total) + " " + response.currencyCode
            
            self.payButton.setTitle("Pay now " + String(response.total) + " " + response.currencyCode, for: . normal)
            
        }.store(in: &bindings)
        
        viewModel!.$orderCreatedID.sink { response in
            if response != 0 {
                let newViewController = CheckoutSucessView()
                newViewController.orderID = response
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
    }

}

extension CheckoutView: SelectLocationDelegate {
    func didLocationSelected(location: UserAddress) {
        self.viewModel?.selectedLocation = location
        self.viewModel?.updateCart()
    }
}
