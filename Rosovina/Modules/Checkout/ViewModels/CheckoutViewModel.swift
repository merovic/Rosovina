//
//  CheckoutViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import Foundation
import Combine
import Firebase
import MFSDK

class CheckoutViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var recipientNameValidationState: ValidationState = .idle
    
    @Published var recipientPhoneValidationState: ValidationState = .idle
    
    @Published var recipientNameText = ""
    
    @Published var recipientPhoneCode = "+966"
    
    @Published var recipientPhoneText = ""
    
    @Published var deliveryDate = Date()
    
    @Published var deliveryDateText = ""
    
    @Published var availableSlots: [GetSlotsAPIResponseElement] = []
    
    @Published var selectedSlot: GetSlotsAPIResponseElement?
            
    @Published var invoiceValue = 0
    
    @Published var paymentMethodID: PaymentMethod = .visa
            
    @Published var cartResponse: GetCartAPIResponse
    
    @Published var selectedLocation: UserAddress?
    
    @Published var selectedLocationForAPI: UserAddress?
    
    @Published var orderCreatedID = 0
    
    @Published var orderConfirmed = false
    
    @Published var errorMessage = ""
                                        
    @Published var isAnimating = false
    
    let token = UIDevice.current.identifierForVendor!.uuidString
                
    //---------------------
        
    let dataService: CheckoutService
    let cartService: CartService
    
    init(dataService: CheckoutService = AppCheckoutService(), cartService: CartService = AppCartService(), cartResponse: GetCartAPIResponse) {
        self.dataService = dataService
        self.cartService = cartService
        self.cartResponse = cartResponse
        self.invoiceValue = cartResponse.total
    }
    
    func checkForPhone(phone: String, code: String) -> String{
        let fCode = code.replacingOccurrences(of: "+", with: "")
        if !phone.starts(with: "0"){
            return fCode + phone
        }else{
            return fCode + phone.dropFirst()
        }
    }
    
    func getSlots() {
        dataService.getSlots(date: deliveryDateText)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    self.availableSlots = response.data ?? []
                    if !self.availableSlots.isEmpty {
                        self.selectedSlot = response.data![0]
                    }
                }
            )
            .store(in: &cancellables)
    }
        
    func createOrder() {
        
        self.isAnimating = true

        dataService.createOrder(request: CreateOrderAPIRequest(mobileToken: token, slotID: selectedSlot!.id, slotDate: deliveryDateText, slotText: selectedSlot!.text))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    self.orderCreatedID = response.data ?? 0
                    if !response.success {
                        self.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func confirmOrder(orderID: Int, paymentReference: String) {
        
        self.isAnimating = true

        dataService.confirmOrder(request: ConfirmOrderAPIRequest(deviceToken: token, orderID: orderID, paymentMethodID: paymentMethodID == .cash ? 2 : 1, paymentReference: paymentReference))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    self.orderConfirmed = response.success
                    if !response.success {
                        self.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func updateCart() {
        self.selectedLocationForAPI = selectedLocation
        
        cartService.updateCart(request: UpdateCartAPIRequest(addressID: self.selectedLocationForAPI?.id))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    self.cartResponse = response.data!
                    if !response.success {
                        self.errorMessage = response.message
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func initiateSDK(){
        
        let initiatePayment = MFInitiatePaymentRequest(invoiceAmount: Decimal(invoiceValue), currencyIso: .saudiArabia_SAR)
        
        MFPaymentRequest.shared.initiatePayment(request: initiatePayment, apiLanguage: .english) { [weak self] (response) in
            switch response {
            case .success(let initiatePaymentResponse):
                if let paymentMethods = initiatePaymentResponse.paymentMethods, !paymentMethods.isEmpty {
                    self?.excutePayment()
                }
            case .failure(let failError):
                print(failError.localizedDescription)
                self?.errorMessage = failError.localizedDescription
            }
        }
    }
    
    func excutePayment(){
        let request = MFExecutePaymentRequest(invoiceValue: Decimal(invoiceValue), paymentMethod: 2)
         
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { [weak self] (response,invoiceId) in
            switch response {
            case .success(let executePaymentResponse):
                for item in executePaymentResponse.invoiceTransactions ?? []{
                    print(item.referenceID ?? "")
                }
                print(executePaymentResponse.invoiceID ?? 0)
                print("\(executePaymentResponse.invoiceStatus ?? "")")
                self?.confirmOrder(orderID: self?.orderCreatedID ?? 0, paymentReference: String(executePaymentResponse.invoiceID ?? 0))
            case .failure(let failError):
                print(failError.localizedDescription)
                self?.errorMessage = failError.localizedDescription
            }
        }

    }
            
}


enum PaymentMethod: Identifiable {
    case cash, visa
    var id: Int {
        self.hashValue
    }
}
