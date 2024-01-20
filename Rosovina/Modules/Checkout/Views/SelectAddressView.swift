//
//  SelectAddressView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 05/01/2024.
//

import UIKit
import Combine
import CombineCocoa
import SwiftUI

protocol SelectLocationDelegate {
    func didLocationSelected(location: UserAddress)
}

class SelectAddressView: UIViewController {

    private var bindings = Set<AnyCancellable>()
    
    var viewModel: SelectAddressViewModel = SelectAddressViewModel()
    
    private let loadingView = LoadingAnimation()
    
    var delegate: SelectLocationDelegate!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: SelectAddressSwiftUIView(viewModel: self.viewModel), parent: self)
    }
    
    func BindViews(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        viewModel.$selectedAddress.sink { response in
            if response != nil{
                self.delegate.didLocationSelected(location: response!)
                self.dismiss(animated: true)
            }
        }.store(in: &bindings)
        
    }

}

struct SelectAddressSwiftUIView: View {
    
    @ObservedObject var viewModel: SelectAddressViewModel
    
    //Radio_unchecked
    
    var body: some View {
        ZStack(alignment: .center){
            if self.viewModel.userAddresses.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(self.viewModel.userAddresses) { item in
                        AddressitemSwiftUIView(address: item)
                            .onTapGesture {
                                self.viewModel.selectedAddress = item
                            }
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
