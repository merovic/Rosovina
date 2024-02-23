//
//  AddressListView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class AddressListView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: AddressesViewModel = AddressesViewModel()
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: AddressSwiftUIView(viewModel: self.viewModel), parent: self)
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


struct AddressSwiftUIView: View {
    
    @ObservedObject var viewModel: AddressesViewModel
    
    var body: some View {
        ZStack(alignment: .center){
            if self.viewModel.userAddresses.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(self.viewModel.userAddresses) { item in
                        AddressitemSwiftUIView(address: item)
                    }
                }
            }else{
                VStack{
                    Text("Address List is Empty")
                        .font(.poppinsFont(size: 25, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    Spacer().frame(height: 300)
                }
            }
        }
        
    }
    
}

struct AddressitemSwiftUIView: View {
    
    var address: UserAddress
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack{
                HStack{
                    Text(address.name ?? "")
                        .font(.poppinsFont(size: 16, weight: .bold))
                        .foregroundColor(Color.black)
                    if address.isDefault {
                        Text(" (default)")
                            .font(.poppinsFont(size: 16, weight: .bold))
                            .foregroundColor(Color.gray)
                    }
                }
                
                Spacer()
                Image("Edit")
                    .resizable()
                    .frame(width: 14, height: 14)
            }
            
            Text(LoginDataService.shared.getMobileNumber())
                .font(.poppinsFont(size: 16, weight: .regular))
                .foregroundColor(Color.black)
            
            Text(address.address ?? "")
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .font(.poppinsFont(size: 14, weight: .regular))
                .foregroundColor(Color.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .cardGrayBackground()
    }
}
