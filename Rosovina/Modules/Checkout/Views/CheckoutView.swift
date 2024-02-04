//
//  CheckoutView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import UIKit
import Combine
import CombineCocoa
import MFSDK

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
    
    var creditCardGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var creditCardView: UIView! {
        didSet {
            creditCardView.rounded()
            creditCardView.addGestureRecognizer(creditCardGest)
        }
    }
    
    var codGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var codView: UIView! {
        didSet {
            codView.rounded()
            codView.addGestureRecognizer(codGest)
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
        MFSettings.shared.delegate = self
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
            print("Updated value received : \(updatedValue)")
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
                let navigationController = UINavigationController(rootViewController: newViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }
            .store(in: &bindings)
        
        addAddressInitButton.tapPublisher
            .sink { _ in
                let newViewController = LocationPickerView()
                let navigationController = UINavigationController(rootViewController: newViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
                navigationController.setNavigationBarHidden(true, animated: false)
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
        
        creditCardGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.paymentMethodID = .visa
            })
            .store(in: &bindings)
        
        codGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.paymentMethodID = .cash
            })
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
        
        viewModel!.$errorMessage.sink { message in
            if message != "" {
                Alert.show("Order Failed", message: message, context: self)
            }
        }.store(in: &bindings)
        
        viewModel!.$orderCreatedID.sink { response in
            if response != 0 {
                if self.viewModel?.paymentMethodID == .cash {
                    self.viewModel?.confirmOrder(orderID: response, paymentReference: String(response))
                }else{
                    self.viewModel!.initiateSDK()
                }
            }
        }.store(in: &bindings)
        
        viewModel!.$orderConfirmed.sink { response in
            if response{
                let newViewController = CheckoutSucessView()
                newViewController.orderID = self.viewModel!.orderCreatedID
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel!.$paymentMethodID.sink { paymentMethod in
            if paymentMethod == .cash{
                self.codView.backgroundColor = UIColor.init(named: "OnionColor")
                self.creditCardView.backgroundColor = UIColor.init(named: "LightGray")
            }else{
                self.creditCardView.backgroundColor = UIColor.init(named: "OnionColor")
                self.codView.backgroundColor = UIColor.init(named: "LightGray")
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


extension CheckoutView: MFPaymentDelegate {
    func didInvoiceCreated(invoiceId: String) {
        print("#\(invoiceId)")
    }
}
