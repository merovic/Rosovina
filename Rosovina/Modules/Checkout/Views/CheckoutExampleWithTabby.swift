//
//  CheckoutExampleWithTabby.swift
//  Rosovina
//
//  Created by Amir Ahmed on 31/03/2024.
//

import SwiftUI
import Tabby

struct CheckoutExampleWithTabby: View {
    @State var isTabbyInstallmentsAvailable = true

    @State var openedProduct: TabbyProductType = .installments
    @State var payload: TabbyCheckoutPayload?
    @State var isTabbyOpened: Bool = false

    init(payload: TabbyCheckoutPayload){
        self.payload = payload
    }
    
    var body: some View {
        VStack {
            Button(action: {
                openedProduct = .installments
                isTabbyOpened = true
            }, label: {
                HStack {
                    Text("My Tabby 'Installments' fancy Button")
                        .font(.headline)
                        .foregroundColor(isTabbyInstallmentsAvailable ? .black : .white)
                }
            })
            .disabled(!isTabbyInstallmentsAvailable)

        }
        .sheet(isPresented: $isTabbyOpened, content: {
            TabbyCheckout(productType: openedProduct, onResult: { result in
                print("TABBY RESULT: \(result)!!!")
                switch result {
                case .authorized:
                    // Do something else when Tabby authorized customer
                    // probably navigation back to Home screen, refetching, etc.
                    self.isTabbyOpened = false
                    break
                case .rejected:
                    // Do something else when Tabby rejected customer
                    self.isTabbyOpened = false
                    break
                case .close:
                    // Do something else when customer closed Tabby checkout
                    self.isTabbyOpened = false
                    break
                case .expired:
                    // Do something else when session expired
                    // We strongly recommend to create new session here by calling
                    // TabbySDK.shared.configure(forPayment: myTestPayment) { result in ... }
                    self.isTabbyOpened = false
                    break
                }
            })
        })
        .onAppear() {
            if payload != nil {
                TabbySDK.shared.configure(forPayment: payload!) { result in
                    switch result {
                    case .success(let s):
                        // 1. Do something with sessionId (this step is optional)
                        print("sessionId: \(s.sessionId)")
                        // 2. Do something with paymentId (this step is optional)
                        print("paymentId: \(s.paymentId)")
                        // 3. Grab avaibable products from session and enable proper
                        // payment method buttons in your UI (this step is required)
                        // Feel free to ignore products you don't need or don't want to handle in your App
                        print("tabby available products: \(s.tabbyProductTypes)")
                        // If you want to handle installments product - check for .installments in response
                        if (s.tabbyProductTypes.contains(.installments)) {
                            self.isTabbyInstallmentsAvailable = true
                        }
                    case .failure(let error):
                        // Do something when Tabby checkout session POST requiest failed
                        print(error)
                    }
                }
            }
        }
    }
}
