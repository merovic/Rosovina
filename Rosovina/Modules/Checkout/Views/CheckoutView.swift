//
//  CheckoutView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import MFSDK

class CheckoutView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: CheckoutViewModel?
    
    var countryPickerViewModel: CountryPickerViewModel = CountryPickerViewModel()
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backbutton: UIButton!
    
    @IBOutlet weak var customSwitch: UISwitch! {
        didSet {
            customSwitch.isOn = false
        }
    }
    
    @IBOutlet weak var addAddressStack: UIStackView!
    
    @IBOutlet weak var addAddressButton: UIButton!
    
    @IBOutlet weak var addAddressInitButton: UIButton! {
        didSet {
            addAddressInitButton.isHidden = true
            addAddressInitButton.prettyHareefButton(radius: 16)
        }
    }
    @IBOutlet weak var addressView: UIView! {
        didSet {
            addressView.isHidden = true
            addressView.rounded()
        }
    }
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var selectedAddressName: UILabel!
    @IBOutlet weak var selectedAddressPhone: UILabel!
    @IBOutlet weak var selectedAddressContent: UILabel!
    
    
    @IBOutlet weak var recipientNameView: UIView! {
        didSet {
            recipientNameView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var recipientNameTextField: UITextField!
    
    @IBOutlet weak var recipientPhoneView: UIView! {
        didSet {
            recipientPhoneView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var countryPickerView: UIView!
    
    @IBOutlet weak var recipientPhoneTextField: UITextField!
    
    var creditCardGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    
    @IBOutlet weak var deliveryDateView: UIView! {
        didSet {
            deliveryDateView.roundedGrayHareefView()
        }
    }
    
    @IBOutlet weak var deliveryDateTextField: UITextField!
    
    @IBOutlet weak var slotsContainer: UIView! {
        didSet {
            slotsContainer.isHidden = true
        }
    }
    
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
    
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        BindViews()
        AttachViews()
        MFSettings.shared.delegate = self
        // Add observer for the custom notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidUpdateValue(_:)), name: .didUpdateValue, object: nil)
    }
    
    func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        deliveryDateTextField.inputView = datePicker
        
        // Add toolbar with "Done" button to dismiss date picker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        deliveryDateTextField.inputAccessoryView = toolbar
    }
    
    func AttachViews() {
        self.countryPickerView.EmbedSwiftUIView(view: CountryPicker(viewModel: countryPickerViewModel), parent: self)
        self.slotsContainer.EmbedSwiftUIView(view: SlotsSwiftUIView(viewModel: viewModel!), parent: self)
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
        
        datePicker?.datePublisher
            .sink { date in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                self.deliveryDateTextField.text = dateFormatter.string(from: date)
                self.viewModel?.deliveryDate = date
                self.viewModel?.deliveryDateText = dateFormatter.string(from: date)
                self.viewModel?.getSlots()
            }
            .store(in: &bindings)
        
        customSwitch.isOnPublisher
            .sink { state in
                self.addAddressStack.isHidden = state
            }
            .store(in: &bindings)
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel!.recipientPhoneCode = code
        }.store(in: &bindings)
        
        recipientNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.recipientNameText, on: viewModel!)
        .store(in: &bindings)
        
        recipientPhoneTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.recipientPhoneText, on: viewModel!)
        .store(in: &bindings)
        
        addAddressButton.tapPublisher
            .sink { _ in
                let newViewController = LocationPickerView()
                let navigationController = UINavigationController(rootViewController: newViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
                navigationController.setNavigationBarHidden(true, animated: false)
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
        
        viewModel!.$availableSlots.sink { slots in
            if !slots.isEmpty {
                self.slotsContainer.isHidden = false
            }else{
                self.slotsContainer.isHidden = true
            }
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
    
    @objc func dismissPicker() {
        deliveryDateTextField.resignFirstResponder()
    }

}

extension CheckoutView: SelectLocationDelegate {
    func didLocationSelected(location: UserAddress) {
        self.viewModel?.selectedLocation = location
        self.viewModel?.recipientNameText = location.receiverName
        self.viewModel?.recipientPhoneText = location.receiverPhone
        self.viewModel?.updateCart()
    }
}


extension CheckoutView: MFPaymentDelegate {
    func didInvoiceCreated(invoiceId: String) {
        print("#\(invoiceId)")
    }
}


struct SlotsSwiftUIView: View {
    
    @ObservedObject var viewModel: CheckoutViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(self.viewModel.availableSlots) { slot in
                    SlotsItemSwiftUIView(slot: slot, viewModel: viewModel)
                }
                Spacer()
            }
        }
    }
}

struct SlotsItemSwiftUIView: View {
    var slot: GetSlotsAPIResponseElement
    
    @ObservedObject var viewModel: CheckoutViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(getFirstDate())
                    .lineLimit(1)
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .foregroundColor(SwiftUI.Color("AccentColor"))
                
                Spacer().frame(height: 5)
                
                Text(getSecondDate())
                    .lineLimit(1)
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .foregroundColor(SwiftUI.Color.black)
                
                Text(slot.text)
                    .lineLimit(1)
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(SwiftUI.Color.gray)
                
            }.padding(5)
        }
        .frame(minWidth: 120, maxWidth: 120, minHeight: 120, maxHeight: 120, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(viewModel.selectedSlot?.id == slot.id ? SwiftUI.Color("AccentColor") : SwiftUI.Color.gray , lineWidth: viewModel.selectedSlot?.id == slot.id ? 3 : 1)
        )
        .cornerRadius(8)
        .onTapGesture {
            viewModel.selectedSlot = slot
        }
    }
    
    func getFirstDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self.viewModel.deliveryDate)
    }
    
    func getSecondDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self.viewModel.deliveryDate)
    }
}
