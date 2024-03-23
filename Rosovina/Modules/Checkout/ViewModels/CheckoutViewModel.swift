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
    
    var egyptValidationSubscription: AnyCancellable?
    var saudiArabiaValidationSubscription: AnyCancellable?
    
    @Published var recipientNameValidationState: ValidationState = .idle
    
    @Published var recipientPhoneValidationState: ValidationState = .idle
    
    @Published var recipientNameText = ""
    
    @Published var recipientPhoneCode = "+966"
    
    @Published var recipientPhoneText = ""
    
    @Published var deliveryDate = Date()
    
    @Published var deliveryDateText = ""
    
    @Published var paymentMethods: [PaymentMethodItem] = []
    
    @Published var selectedPaymentMethod: PaymentMethodItem?
    
    @Published var availableSlots: [GetSlotsAPIResponseElement] = []
    
    @Published var selectedSlot: GetSlotsAPIResponseElement?
            
    @Published var invoiceValue = 0
                
    @Published var cartResponse: GetCartAPIResponse
    
    @Published var selectedLocation: UserAddress?
    
    @Published var selectedLocationForAPI: UserAddress?
    
    @Published var orderCreatedID = 0
    
    @Published var orderConfirmed = false
    
    @Published var unauthenticated = false
    
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
        
        getPaymentMethods()
    }
    
    func checkForPhone(phone: String, code: String) -> String{
        let fCode = code.replacingOccurrences(of: "+", with: "")
        if !phone.starts(with: "0"){
            return fCode + phone
        }else{
            return fCode + phone.dropFirst()
        }
    }
    
    func getPaymentMethods() {
        dataService.getPaymentMethods()
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
                    self.paymentMethods = response.data ?? []
                    self.selectedPaymentMethod = self.paymentMethods[0]
                }
            )
            .store(in: &cancellables)
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
                        self.unauthenticated = true
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

        dataService.confirmOrder(request: ConfirmOrderAPIRequest(deviceToken: token, orderID: orderID, paymentMethodID: selectedPaymentMethod?.id ?? 1, paymentReference: paymentReference))
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
           
}
