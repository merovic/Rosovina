//
//  TabbyCheckoutView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 25/03/2024.
//

import UIKit
import SwiftUI
import Combine
import Tabby

protocol TabbyCheckoutDelegate {
    func didTabbyCheckoutSuccess(state: Bool)
}

class TabbyCheckoutView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: TabbyViewModel?
    
    var delegate: TabbyCheckoutDelegate!

    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.container.EmbedSwiftUIView(view: CheckoutExampleWithTabby(payload: viewModel!.tabbyPayment!), parent: self)
        
//        viewModel!.$tabbyResult.sink { result in
//            if result != nil {
//                switch result {
//                case .authorized:
//                    // Do something else when Tabby authorized customer
//                    // probably navigation back to Home screen, refetching, etc.
//                    self.delegate.didTabbyCheckoutSuccess(state: true)
//                    self.navigationController?.popViewController(animated: true)
//                case .rejected:
//                    // Do something else when Tabby rejected customer
//                    self.delegate.didTabbyCheckoutSuccess(state: false)
//                    self.navigationController?.popViewController(animated: true)
//                case .close:
//                    // Do something else when customer closed Tabby checkout
//                    self.delegate.didTabbyCheckoutSuccess(state: false)
//                    self.navigationController?.popViewController(animated: true)
//                case .expired:
//                    // Do something else when session expired
//                    // We strongly recommend to create new session here by calling
//                    TabbySDK.shared.configure(forPayment: self.viewModel!.tabbyPayment!) { result in
//                        switch result {
//                        case .success(let s):
//                            // 1. Do something with sessionId (this step is optional)
//                            print("sessionId: \(s.sessionId)")
//                            // 2. Do something with paymentId (this step is optional)
//                            print("paymentId: \(s.paymentId)")
//                            // 2. Grab avaibable products from session and enable proper
//                            // payment method buttons in your UI (this step is required)
//                            print("tabby available products: \(s.tabbyProductTypes)")
//                            if (s.tabbyProductTypes.contains(.installments)) {
//
//                            }
//                        case .failure(let error):
//                            // Do something when Tabby checkout session POST requiest failed
//                            print(error)
//                        }
//                    }
//                case .none:
//                    print("TABBY RESULT FAILED !")
//                }
//            }
//
//        }.store(in: &bindings)
        
    }

}

struct TabbyCheckoutSwiftUIView: View {
    
    @ObservedObject var viewModel: TabbyViewModel
    
    var body: some View {
        ZStack{
            TabbyCheckout(productType: .credit_card_installments, onResult: { result in
                self.viewModel.tabbyResult = result
                print("TABBY RESULT: \(result) !")
            })
        }.frame(width: .infinity, height: .infinity)
    }
}
