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
import PassKit
import TamaraSDK

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
    
    @IBOutlet weak var recipientView: UIView!
    
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
    
    @IBOutlet weak var recipientPhoneErrorMessage: UILabel!
    
    var creditCardGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var applePayGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var tamaraGest: UITapGestureRecognizer = {
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
    
    @IBOutlet weak var applePayView: UIView! {
        didSet {
            applePayView.rounded()
            applePayView.addGestureRecognizer(applePayGest)
        }
    }
    
    @IBOutlet weak var tamaraView: UIView! {
        didSet {
            tamaraView.roundedLightGrayHareefView()
            tamaraView.addGestureRecognizer(tamaraGest)
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
    var tamaraSDK: TamaraSDKCheckout!
    var response: TamaraInitResponse?
    
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
        datePicker?.preferredDatePickerStyle = .wheels
        
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
        
        viewModel!.$unauthenticated.sink { state in
            if state {
                LoginDataService.shared.setLogout()
                let newViewController = LoginView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        datePicker?.datePublisher
            .sink { date in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.deliveryDateTextField.text = dateFormatter.string(from: date)
                self.viewModel?.deliveryDate = date
                self.viewModel?.deliveryDateText = dateFormatter.string(from: date)
                self.viewModel?.getSlots()
            }
            .store(in: &bindings)
        
        customSwitch.isOnPublisher
            .sink { state in
                self.addAddressStack.isHidden = state
                self.recipientView.isHidden = !state
                if state{
                    self.viewModel?.selectedLocation = nil
                }else{
                    self.viewModel?.recipientNameText = ""
                    self.viewModel?.recipientPhoneText = ""
                    if self.viewModel?.cartResponse.addressID != nil {
                        
                        self.viewModel?.selectedLocation = self.viewModel?.cartResponse.address
                        
                        self.addAddressInitButton.isHidden = true
                        self.addAddressButton.isHidden = false
                        self.addressView.isHidden = false
                        
                        self.selectedAddressName.text = self.viewModel?.cartResponse.address?.name
                        self.selectedAddressContent.text = self.viewModel?.cartResponse.address?.address
                        self.selectedAddressPhone.text = self.viewModel?.cartResponse.address?.receiverPhone
                    }
                }
            }
            .store(in: &bindings)
        
        recipientNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.recipientNameText, on: viewModel!)
        .store(in: &bindings)
        
        countryPickerViewModel.$phoneCode.sink { code in
            self.viewModel?.recipientPhoneCode = code
            self.viewModel?.recipientPhoneText = ""
            self.recipientPhoneTextField.text = ""
            self.viewModel?.recipientPhoneValidationState = .idle
            self.recipientPhoneErrorMessage.text = ""
            
            self.viewModel?.egyptValidationSubscription?.cancel()
            self.viewModel?.saudiArabiaValidationSubscription?.cancel()
            
            if code == "+966"{
                self.subscripeSaudiArabia()
            }else{
                self.subscripeEgypt()
            }
        }.store(in: &bindings)
        
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
        
        applePayGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.paymentMethodID = .applePay
            })
            .store(in: &bindings)
        
        tamaraGest.tapPublisher
            .sink(receiveValue:{_ in
                self.viewModel?.paymentMethodID = .tamara
            })
            .store(in: &bindings)
        
        payButton.tapPublisher
            .sink { _ in
                if self.customSwitch.isOn {
                    if self.viewModel?.recipientNameText != "" && self.viewModel?.recipientPhoneText != ""{
                        self.viewModel?.createOrder()
                    }else{
                        Alert.show("Cant Complete Order", message: "Fill the Recipient Name and Phone First", context: self)
                    }
                }else{
                    if self.viewModel?.cartResponse.address != nil{
                        self.viewModel?.createOrder()
                    }else{
                        Alert.show("Cant Complete Order", message: "Select a Delivery Address First", context: self)
                    }
                }
            }
            .store(in: &bindings)
        
        viewModel!.$cartResponse.sink { response in
            if response.addressID != nil {
                self.viewModel?.selectedLocation = response.address
                
                self.addAddressInitButton.isHidden = true
                self.addAddressButton.isHidden = false
                self.addressView.isHidden = false
                
                self.selectedAddressName.text = response.address?.name
                self.selectedAddressContent.text = response.address?.address
                self.selectedAddressPhone.text = response.address?.receiverPhone
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
                switch self.viewModel?.paymentMethodID {
                case .cash:
                    self.viewModel?.confirmOrder(orderID: response, paymentReference: String(response))
                case .visa:
                    self.initiateMyFatoorahSDK()
                case .applePay:
                    self.initiateApplePay()
                case .tamara:
                    self.initiateTamaraSDK()
                default:
                    print("")
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
            switch paymentMethod {
            case .cash:
                self.codView.roundedLightGrayHareefView()
                self.creditCardView.backgroundColor = UIColor.init(named: "LightGray")
                self.applePayView.roundedLightGrayHareefView()
                self.tamaraView.rounded()
            case .visa:
                self.creditCardView.roundedBlackHareefView()
                self.codView.backgroundColor = UIColor.init(named: "LightGray")
                self.applePayView.roundedLightGrayHareefView()
                self.tamaraView.roundedLightGrayHareefView()
            case .applePay:
                self.creditCardView.roundedLightGrayHareefView()
                self.codView.backgroundColor = UIColor.init(named: "LightGray")
                self.applePayView.roundedBlackHareefView()
                self.tamaraView.roundedLightGrayHareefView()
            case .tamara:
                self.creditCardView.roundedLightGrayHareefView()
                self.codView.backgroundColor = UIColor.init(named: "LightGray")
                self.applePayView.roundedLightGrayHareefView()
                self.tamaraView.roundedBlackHareefView()
            }
            
        }.store(in: &bindings)
        
    }
    
    func subscripeEgypt(){
        viewModel!.egyptValidationSubscription = recipientPhoneTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .phone(country: .egypt))
            .assign(to: \.recipientPhoneValidationState, on: viewModel!)
    }
    
    func subscripeSaudiArabia(){
        viewModel!.saudiArabiaValidationSubscription = recipientPhoneTextField.textPublisher
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .validateText(validationType: .phone(country: .saudiArabia))
            .assign(to: \.recipientPhoneValidationState, on: viewModel!)
    }
    
    @objc func dismissPicker() {
        deliveryDateTextField.resignFirstResponder()
    }
}

extension CheckoutView{
    func initiateMyFatoorahSDK(){
        let initiatePayment = MFInitiatePaymentRequest(invoiceAmount: Decimal(viewModel!.invoiceValue), currencyIso: .saudiArabia_SAR)
        
        MFPaymentRequest.shared.initiatePayment(request: initiatePayment, apiLanguage: .english) { [weak self] (response) in
            switch response {
            case .success(let initiatePaymentResponse):
                if let paymentMethods = initiatePaymentResponse.paymentMethods, !paymentMethods.isEmpty {
                    self?.excutePayment()
                }
            case .failure(let failError):
                print(failError.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    Alert.show("Payment Error", message: failError.localizedDescription, context: self!)
                }
            }
        }
    }
    
    func excutePayment(){
        let request = MFExecutePaymentRequest(invoiceValue: Decimal(viewModel!.invoiceValue), paymentMethod: 2)
         
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] (response,invoiceId) in
            switch response {
            case .success(let executePaymentResponse):
                for item in executePaymentResponse.invoiceTransactions ?? []{
                    print(item.referenceID ?? "")
                }
                print(executePaymentResponse.invoiceID ?? 0)
                print("\(executePaymentResponse.invoiceStatus ?? "")")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.viewModel!.confirmOrder(orderID: self?.viewModel!.orderCreatedID ?? 0, paymentReference: String(executePaymentResponse.invoiceID ?? 0))
                }
            case .failure(let failError):
                print(failError.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    Alert.show("Payment Error", message: failError.localizedDescription, context: self!)
                }
                
            }
        }

    }
}

extension CheckoutView: TamaraCheckoutDelegate {
    
    func initiateTamaraSDK(){
        let API_URL = "https://api-sandbox.tamara.co"
        let AUTH_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiJkMDcxZjFkOC1lMGJhLTQ4MzctYmRjOS01Zjc3MmIzZmJhMDMiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiYWU0NmNkYjZiMGY1MzAyNDdkN2VhOWNjMTlkZjZiMjUiLCJyb2xlcyI6WyJST0xFX01FUkNIQU5UIl0sImlhdCI6MTcwOTU0MjEyNCwiaXNzIjoiVGFtYXJhIn0.hKehcSvMM1E-rKzipu2s5ohPlIj51UksPvu7Br_fQh84IAS1MziBM4yY-HS7g81c-WUB25DdCNte-2QW671s0sFv5uCgCOEGzvXCkn1A547WIZKJutjNqk_bbqR-91_ZW0E6IZp_y9SuyZq5xCMOLXk2oYkozihNpH8HlEq6Iie9fEqeuTKcJnSHdrs_kwnWdgcCIaJP24-gAIQzVYlPtzL3JohwLD3YcmMA-Fol6dcvDey6DH5xfaEzj8qFSNDF51zM7uiEH6wXC1wmw3Geb_FYKlnOQygxZbtGE1Z52y3VEFE1mdLBoQTDZq7OFUoQM2aD5U1kruKMF09PKv-WRg"
        let NOTIFICATION_WEB_HOOK_URL = "https://pro.rosovina.com/public/api/payment/tamara/webhook/q8DLKT8Bt3Yd1uDH52ej360?payment_method_id=3"
        let PUBLISH_KEY = "9fd3e4dc-d3a1-4226-ac14-1b8d7c58c37d"
        let NOTIFICATION_TOKEN = "1e16086f-05fe-443a-85d4-92748bad4267"
        
        let tamaraOrder = TamaraSDKPayment()
        
        tamaraOrder.initialize(token: AUTH_TOKEN, apiUrl: API_URL, pushUrl: NOTIFICATION_WEB_HOOK_URL, publishKey: PUBLISH_KEY, notificationToken: NOTIFICATION_TOKEN, isSandbox: true)
        
        tamaraOrder.createOrder(orderReferenceId: String(self.viewModel!.cartResponse.id), description: self.viewModel!.cartResponse.items[0].productName)
        
        let userFirstName = String(LoginDataService.shared.getFullName().split(separator: " ")[0])
        
        let userLastName = LoginDataService.shared.getFullName().split(separator: " ").count > 1 ? String(LoginDataService.shared.getFullName().split(separator: " ")[1]) : ""
        
        tamaraOrder.setCustomerInfo(firstName: userFirstName, lastName: userLastName, phoneNumber: LoginDataService.shared.getMobileNumber(), email: LoginDataService.shared.getEmail())
        
        for item in self.viewModel!.cartResponse.items {
            tamaraOrder.addItem(name: item.productName, referenceId: item.id, sku: item.sku ?? "", type: "Rosovina Product", unitPrice: Double(item.unitPrice), tax: Double(item.taxAmount), discount: Double(item.discountAmount), quantity: Int(item.quantity) ?? 1)
        }
        
        tamaraOrder.setShippingAddress(firstName: userFirstName, lastName: userLastName, phoneNumber: LoginDataService.shared.getMobileNumber(), addressLine1: self.viewModel!.cartResponse.address?.name ?? "", addressLine2: self.viewModel!.cartResponse.address?.name ?? "", country: "SA", region: self.viewModel!.cartResponse.address?.areaName ?? "", city: LoginDataService.shared.getUserCity().name)
        tamaraOrder.setBillingAddress(firstName: userFirstName, lastName: userLastName, phoneNumber: LoginDataService.shared.getMobileNumber(), addressLine1: self.viewModel!.cartResponse.address?.name ?? "", addressLine2: self.viewModel!.cartResponse.address?.name ?? "", country: "SA", region: self.viewModel!.cartResponse.address?.areaName ?? "", city: LoginDataService.shared.getUserCity().name)
        tamaraOrder.setShippingAmount(amount: 10)
        tamaraOrder.setInstalments(instalments: 4)
        
        tamaraOrder.startPayment { (completion) in
            switch completion {
            case .success(let success):
                guard let orderID = success.dictionary?["order_id"] as? String,
                      let checkoutURL = success.dictionary?["checkout_url"] as? String else {
                    fatalError("Invalid dictionary format")
                }

                self.response = TamaraInitResponse(order_id: orderID, checkout_url: checkoutURL)
                print(self.response!)
                self.TamaraSDKCheckout(response: self.response!)
                
//                tamaraOrder.orderDetail(orderId: response.order_id) { (completion) in
//                    switch completion {
//                    case .success(let details):
//                        print(details.convertToJson())
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func TamaraSDKCheckout(response: TamaraInitResponse){
        let merchantUrl = TamaraMerchantURL(
            success: "tamara://checkout/success",
            failure: "tamara://checkout/failure",
            cancel: "tamara://checkout/cancel",
            notification: "tamara://checkout/notification"
        )
        
        tamaraSDK = TamaraSDK.TamaraSDKCheckout(url: response.checkout_url, merchantURL: merchantUrl)
        tamaraSDK.delegate = self
        tamaraSDK.modalPresentationStyle = .fullScreen
        self.present(tamaraSDK, animated: true, completion: nil)
    }
    
    func onSuccessfull() {
        tamaraSDK.dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.viewModel!.confirmOrder(orderID: self.viewModel!.orderCreatedID, paymentReference: self.response!.order_id)
            }
        }
    }
    
    func onFailured() {
        tamaraSDK.dismiss(animated: true) {
            Alert.show("Order Failed", message: "Payment Error, Please try again", context: self)
        }
    }
    
    func onCancel() {
        tamaraSDK.dismiss(animated: true) {
            Alert.show("Order Failed", message: "Order Cancelled", context: self)
        }
    }
}

extension CheckoutView: PKPaymentAuthorizationViewControllerDelegate {
    func initiateApplePay(){
        let paymentRequest: PKPaymentRequest = {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.com.rosovina"
            request.supportedNetworks = [.masterCard, .visa, .mada]
            request.supportedCountries = ["SA", "EG"]
            request.merchantCapabilities = .capability3DS
            request.countryCode = "SA"
            request.currencyCode = "SAR"
             for item in self.viewModel!.cartResponse.items {
                 request.paymentSummaryItems.append(PKPaymentSummaryItem(label: item.productName, amount: NSDecimalNumber(value: item.total)))
             }
            return request
        }()
        
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if let controller = controller {
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController){
            controller.dismiss(animated: true, completion: nil)
        }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let transactionID = payment.token.transactionIdentifier
        print("Transaction ID: \(transactionID)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.viewModel!.confirmOrder(orderID: self.viewModel!.orderCreatedID, paymentReference: transactionID)
        }
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}

extension CheckoutView: SelectLocationDelegate {
    func didLocationSelected(location: UserAddress) {
        self.viewModel?.selectedLocation = location
        
        self.selectedAddressName.text = location.name
        self.selectedAddressContent.text = location.address
        self.selectedAddressPhone.text = location.receiverPhone
        
        self.viewModel?.recipientNameText = location.receiverName ?? ""
        self.viewModel?.recipientPhoneText = location.receiverPhone ?? ""
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
