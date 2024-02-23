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
        
    }

}

struct WalletViewSwiftUIView: View {
    
    @ObservedObject var viewModel: WalletViewModel
        
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                
            }
        }
    }
}

struct TransactionItemViewSwiftUIView: View {
    
    @ObservedObject var viewModel: WalletViewModel
        
    var body: some View {
        HStack{
            Text("Hello, SwiftUI!")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                        )
            
            Text("address.name")
                .font(.poppinsFont(size: 16, weight: .bold))
                .foregroundColor(Color.black)
            
            Text("address.name")
                .font(.poppinsFont(size: 16, weight: .bold))
                .foregroundColor(Color.black)
        }
    }
}
