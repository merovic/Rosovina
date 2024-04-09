//
//  WalletView.swift
//  Rosovina
//
//  Created by PaySky106 on 20/02/2024.
//

import UIKit
import SwiftUI
import Combine

class WalletView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: WalletViewModel = WalletViewModel()
        
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: WalletViewSwiftUIView(viewModel: viewModel), parent: self)
    }
    
    func BindViews(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        viewModel.$userBalance
            .receive(on: DispatchQueue.main)
            .assign(to: \.text!, on: currentBalance)
            .store(in: &bindings)
        
    }

}

struct WalletViewSwiftUIView: View {
    
    @ObservedObject var viewModel: WalletViewModel
        
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                HStack{
                    Spacer().frame(width: 20)
                    
                    Text("operation".localized)
                        .frame(width: .infinity)
                        .font(.poppinsFont(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("description".localized)
                        .frame(width: .infinity)
                        .font(.poppinsFont(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("amount".localized)
                        .frame(width: .infinity)
                        .font(.poppinsFont(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                       
                    Spacer().frame(width: 20)
                }
                Divider()
                ForEach(self.viewModel.userTransactions) { transaction in
                    TransactionItemViewSwiftUIView(transaction: transaction, viewModel: viewModel)
                    Divider()
                }
            }
        }.padding()
    }
}

struct TransactionItemViewSwiftUIView: View {
    
    var transaction: UserTransaction
    @ObservedObject var viewModel: WalletViewModel
        
    var body: some View {
        HStack{
            Spacer().frame(width: 20)
            
            Text(transaction.type == "payment" ? "payment".localized : "refund".localized)
                .font(.poppinsFont(size: 12, weight: .regular))
                .padding(5)
                .background(Color(transaction.type == "payment" ? "OnionColor" : "LightGray"))
                .foregroundColor(Color(transaction.type == "payment" ? "LightBrown" : "DarkGray"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(transaction.type == "payment" ? "LightBrown" : "DarkGray"), lineWidth: 2)
                        )
            
            Spacer()
            
            Text(transaction.description == "" ? "payment_for_new_order".localized : transaction.description)
                .font(.poppinsFont(size: 12, weight: .regular))
                .foregroundColor(Color.gray)
            
            Spacer()
            
            Text(String(transaction.amount) + " " + "SAR".localized)
                .font(.poppinsFont(size: 12, weight: .regular))
                .foregroundColor(Color.gray)
            
            Spacer().frame(width: 20)
        }
    }
}
