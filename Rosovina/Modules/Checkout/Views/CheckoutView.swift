//
//  CheckoutView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa
import MFSDK
import PassKit
import TamaraSDK
import Tabby

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
    
    @IBOutlet weak var paymentMethodsContainer: UIView!
    
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
        let doneButton = UIBarButtonItem(title: "done".localized, style: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        deliveryDateTextField.inputAccessoryView = toolbar
    }
    
    func AttachViews() {
        self.countryPickerView.EmbedSwiftUIView(view: CountryPicker(viewModel: countryPickerViewModel), parent: self)
        self.slotsContainer.EmbedSwiftUIView(view: SlotsSwiftUIView(viewModel: viewModel!), parent: self)
        self.paymentMethodsContainer.EmbedSwiftUIView(view: PaymentMethodsSwiftUIView(viewModel: viewModel!), parent: self)
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
                dateFormatter.locale = Locale(identifier: "en")
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
        
        payButton.tapPublisher
            .sink { _ in
                if self.customSwitch.isOn {
                    if self.viewModel?.recipientNameText != "" && self.viewModel?.recipientPhoneText != ""{
                        self.viewModel?.createOrder()
                    }else{
                        Alert.show("cant_complete_order".localized, message: "fill_the_recipient".localized, context: self)
                    }
                }else{
                    if self.viewModel?.cartResponse.address != nil{
                        self.viewModel?.createOrder()
                    }else{
                        Alert.show("cant_complete_order".localized, message: "select_delivery".localized, context: self)
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
            
            self.payButton.setTitle("pay_now".localized + " " + String(response.total) + " " + response.currencyCode, for: . normal)
            
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
                Alert.show("order_failed".localized, message: message, context: self)
            }
        }.store(in: &bindings)
        
        viewModel!.$orderCreatedID.sink { response in
            if response != 0 {
                switch self.viewModel?.selectedPaymentMethod?.paymentMethod {
                case .CreditCard:
                    self.initiateMyFatoorahSDK()
                case .ApplePay:
                    self.initiateApplePay()
                case .Tamara:
                    self.initiateTamaraSDK()
                case .Tabby:
                    self.initiateTabby()
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
                    Alert.show("payment_error".localized, message: failError.localizedDescription, context: self!)
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
                    Alert.show("payment_error".localized, message: failError.localizedDescription, context: self!)
                }
                
            }
        }

    }
}

extension CheckoutView: TamaraCheckoutDelegate {
    func initiateTamaraSDK(){
        let API_URL = "https://api.tamara.co"
        let AUTH_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhY2NvdW50SWQiOiI0NTBlODgxNS02YmE3LTQzYmQtOTQxNy1iZmQ4ODA5Y2FmNzkiLCJ0eXBlIjoibWVyY2hhbnQiLCJzYWx0IjoiNjkxZmU2ZGI3Mjc2MDg0NmQ4MmJlZmFjZjkwMjc2ZmMiLCJyb2xlcyI6WyJST0xFX01FUkNIQU5UIl0sImlhdCI6MTcwODYwMTEzMSwiaXNzIjoiVGFtYXJhIFBQIn0.C80pwc5niIm9DS-wn0aT3DzwLlJU4gNQjjvsR9vqt-fxFpIc7bopIwet9cSOO94XtVB7eXoApmSTEoSz7n7dtnJClAwaOMzsnHqVmj3uQXSIXufvbEdheLhEyfm7hs9E0azWfikvrSqSyJ4Qvxgvl0N88LUat0Ewg6MSlN-85jm2qY8__pmzTtuKLSIwmDAucizaxIELljQAymjlaBuPxfWB0KZx4PCuMgQjmZcXIXIb9h_hmR3IZr_wyn9syNKppxmNBlOZz7hmhz8sD71G9TE2ixvnIFt0bJwq6kXCuaGyiGdF2Fj63uMtiuOmGmzV6nk39-MZAz4wkb4VSvkGHA"
        let NOTIFICATION_WEB_HOOK_URL = "https://pro.rosovina.com/public/api/payment/tamara/webhook/q8DLKT8Bt3Yd1uDH52ej360?payment_method_id=3"
        let PUBLISH_KEY = "22be66e5-65a4-48b1-a6d9-a9f9d803e8d0"
        let NOTIFICATION_TOKEN = "1e61bba7-0993-4066-b858-cdb9b1ac91ee"
        
        let tamaraOrder = TamaraSDKPayment()
        
        tamaraOrder.initialize(token: AUTH_TOKEN, apiUrl: API_URL, pushUrl: NOTIFICATION_WEB_HOOK_URL, publishKey: PUBLISH_KEY, notificationToken: NOTIFICATION_TOKEN, isSandbox: false)
        
        tamaraOrder.createOrder(orderReferenceId: String(self.viewModel!.cartResponse.id), description: self.viewModel!.cartResponse.items[0].productName)
        
        let userFirstName = String(LoginDataService.shared.getFullName().split(separator: " ")[0])
        
        let userLastName = LoginDataService.shared.getFullName().split(separator: " ").count > 1 ? String(LoginDataService.shared.getFullName().split(separator: " ")[1]) : ""
        
        tamaraOrder.setCustomerInfo(firstName: userFirstName, lastName: userLastName, phoneNumber: LoginDataService.shared.getMobileNumber(), email: LoginDataService.shared.getEmail())
        
        for item in self.viewModel!.cartResponse.items {
            tamaraOrder.addItem(name: item.productName, referenceId: item.id, sku: item.sku ?? "", type: "rosovina_product".localized, unitPrice: Double(item.unitPrice), tax: Double(item.taxAmount), discount: Double(item.discountAmount), quantity: Int(item.quantity) ?? 1)
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
                self.TamaraSDKCheckout(response: self.response!)
                
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
            Alert.show("order_failed".localized, message: "payment_error_please".localized, context: self)
        }
    }
    
    func onCancel() {
        tamaraSDK.dismiss(animated: true) {
            Alert.show("order_failed".localized, message: "order_cancelled".localized, context: self)
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

extension CheckoutView: TabbyCheckoutDelegate {
    func sampleTabby(){
        var tabbyOrderList: [OrderItem] = []
        for item in self.viewModel!.cartResponse.items{
            tabbyOrderList.append(OrderItem(quantity: Int(item.quantity) ?? 1, reference_id: item.sku ?? "", title: item.productName, unit_price: String(item.unitPrice), category: "Flowers"))
        }
        let customerPayment = Payment(
            amount: String(self.viewModel!.cartResponse.total),
            currency: .SAR,
            description: "Rosovina Order #" + String(self.viewModel!.orderCreatedID),
            buyer: Buyer(
                email: LoginDataService.shared.getEmail(),
                phone: LoginDataService.shared.getMobileNumber(),
                name: LoginDataService.shared.getFullName(),
                dob: nil
            ),
            buyer_history: BuyerHistory(registered_since: "2019-08-24T14:15:22Z", loyalty_level: 0),
            order: Order(
                reference_id: "#" + String(self.viewModel!.orderCreatedID),
                items: tabbyOrderList,
                shipping_amount: "10",
                tax_amount: "10"
            ),
            order_history: [],
            shipping_address: ShippingAddress(
                address: self.viewModel?.cartResponse.address?.areaName ?? "",
                city: self.viewModel?.cartResponse.address?.cityName ?? "",
                zip: "22230"
            )
        )

        let myTestPayment = TabbyCheckoutPayload(merchant_code: "Rosovina AppPL", lang: .en, payment: customerPayment)
        
        
        let newViewController = TabbyCheckoutView()
        newViewController.viewModel = TabbyViewModel(myTestPayment: myTestPayment)
        newViewController.delegate = self
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func initiateTabby(){
        var tabbyOrderList: [OrderItem] = []
        for item in self.viewModel!.cartResponse.items{
            tabbyOrderList.append(OrderItem(quantity: Int(item.quantity) ?? 1, reference_id: item.sku ?? "", title: item.productName, unit_price: String(item.unitPrice), category: "Flowers"))
        }
        let customerPayment = Payment(
            amount: String(self.viewModel!.cartResponse.total),
            currency: .SAR,
            description: "Rosovina Order #" + String(self.viewModel!.orderCreatedID),
            buyer: Buyer(
                email: LoginDataService.shared.getEmail(),
                phone: LoginDataService.shared.getMobileNumber(),
                name: LoginDataService.shared.getFullName(),
                dob: nil
            ),
            buyer_history: BuyerHistory(registered_since: "2019-08-24T14:15:22Z", loyalty_level: 0),
            order: Order(
                reference_id: "#" + String(self.viewModel!.orderCreatedID),
                items: tabbyOrderList,
                shipping_amount: "10",
                tax_amount: "10"
            ),
            order_history: [],
            shipping_address: ShippingAddress(
                address: self.viewModel?.cartResponse.address?.areaName ?? "",
                city: self.viewModel?.cartResponse.address?.cityName ?? "",
                zip: "22230"
            )
        )

        let myTestPayment = TabbyCheckoutPayload(merchant_code: "Rosovina AppPL", lang: .en, payment: customerPayment)
        
        TabbySDK.shared.configure(forPayment: myTestPayment) { result in
            switch result {
            case .success(let s):
                // 1. Do something with sessionId (this step is optional)
                print("sessionId: \(s.sessionId)")
                // 2. Do something with paymentId (this step is optional)
                print("paymentId: \(s.paymentId)")
                // 2. Grab avaibable products from session and enable proper
                // payment method buttons in your UI (this step is required)
                print("tabby available products: \(s.tabbyProductTypes)")
                if (s.tabbyProductTypes.contains(.installments)) {
                    let newViewController = TabbyCheckoutView()
                    newViewController.viewModel = TabbyViewModel(myTestPayment: myTestPayment)
                    newViewController.delegate = self
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
            case .failure(let error):
                // Do something when Tabby checkout session POST requiest failed
                print(error)
            }
        }
    }
    
    func didTabbyCheckoutSuccess(state: Bool) {
        if state {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                //self.viewModel!.confirmOrder(orderID: self.viewModel!.orderCreatedID, paymentReference: "")
            }
        }else{
            Alert.show("order_failed".localized, message: "payment_error_please".localized, context: self)
        }
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
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
        return dateFormatter.string(from: self.viewModel.deliveryDate)
    }
    
    func getSecondDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
        return dateFormatter.string(from: self.viewModel.deliveryDate)
    }
}

struct PaymentMethodsSwiftUIView: View {
    
    @ObservedObject var viewModel: CheckoutViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(self.viewModel.paymentMethods) { method in
                    PaymentMethodItemSwiftUIView(paymentMethod: method, viewModel: viewModel)
                }
                Spacer()
            }
        }
    }
}

struct PaymentMethodItemSwiftUIView: View {
    var paymentMethod: PaymentMethodItem
    
    @ObservedObject var viewModel: CheckoutViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                
                if paymentMethod.paymentMethod == .CreditCard {
                    Image(paymentMethod.paymentMethod.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 33, height: 21)
                    
                    Text(paymentMethod.paymentMethod.title)
                        .lineLimit(1)
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .foregroundColor(SwiftUI.Color.black)
                }else{
                    Image(paymentMethod.paymentMethod.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                
            }.padding(5)
        }
        .frame(minWidth: 95, maxWidth: 95, minHeight: 95, maxHeight: 95, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(viewModel.selectedPaymentMethod?.id == paymentMethod.id ? SwiftUI.Color("AccentColor") : SwiftUI.Color.gray , lineWidth: viewModel.selectedPaymentMethod?.id == paymentMethod.id ? 3 : 1)
        )
        .cornerRadius(8)
        .onTapGesture {
            viewModel.selectedPaymentMethod = paymentMethod
        }
    }

}
