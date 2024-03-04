//
//  MyOrdersView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class MyOrdersView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: MyOrdersViewModel = MyOrdersViewModel()
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var container: UIView!
    
    var showBackButton: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
        if showBackButton != nil{
            backButton.isHidden = false
        }
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: MyOrdersSwiftUIView(viewModel: self.viewModel), parent: self)
    }
    
    func BindViews(){
        
        viewModel.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        viewModel.$selectedOrderID.sink { orderID in
            if orderID != nil {
                let newViewController = OrderTrackingView()
                newViewController.viewModel = MyOrderDetailsViewModel(orderID: String(orderID ?? 0))
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        viewModel.$unauthenticated.sink { state in
            if state {
                LoginDataService.shared.setLogout()
                let newViewController = LoginView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
    }

}

struct MyOrdersSwiftUIView: View {
    
    @ObservedObject var viewModel: MyOrdersViewModel
    
    var body: some View {
        ZStack(alignment: .center){
            if self.viewModel.myCurrentOrders.count > 0 || self.viewModel.myHistoryOrders.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    if self.viewModel.myCurrentOrders.count > 0{
                        VStack(alignment: .leading){
                            Text("Processing")
                                .font(.poppinsFont(size: 18, weight: .bold))
                                .foregroundColor(Color.accentColor)
                                .padding(.top, 5)
                            
                            ForEach(self.viewModel.myCurrentOrders) { order in
                                MyOrdersItemSwiftUIView(viewModel: self.viewModel, myOrder: order, isHistory: false)
                            }
                        }
                    }
                    
                    if self.viewModel.myHistoryOrders.count > 0{
                        VStack(alignment: .leading){
                            Text("History")
                                .font(.poppinsFont(size: 18, weight: .bold))
                                .foregroundColor(Color.accentColor)
                            
                            ForEach(self.viewModel.myHistoryOrders) { order in
                                MyOrdersItemSwiftUIView(viewModel: self.viewModel, myOrder: order, isHistory: true)
                                    .onTapGesture {
                                        self.viewModel.selectedOrderID = order.id
                                    }
                            }
                        }
                    }
                    
                }
            }else{
                VStack{
                    Text("Orders List is Empty")
                        .font(.poppinsFont(size: 25, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    Spacer().frame(height: 300)
                }
            }
            
        }
        
    }
    
}

struct MyOrdersItemSwiftUIView: View {
    
    @ObservedObject var viewModel: MyOrdersViewModel
    
    var myOrder: MyOrder
    
    var isHistory: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            WebImage(url: URL(string: myOrder.items.count > 0 ? myOrder.items[0].imageURL : ""))
                .placeholder(Image("logo").resizable())
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(16)
                .frame(width: 91, height: 91)
            
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    Text("Order ID: ")
                        .font(.poppinsFont(size: 16, weight: .bold))
                        .foregroundColor(Color.accentColor)
                    
                    Text(myOrder.code)
                        .font(.poppinsFont(size: 16, weight: .bold))
                        .foregroundColor(Color.accentColor)
                }
                
                HStack{
                    Text(String(myOrder.items.count) + " Products")
                        .font(.poppinsFont(size: 16, weight: .regular))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text(String(myOrder.total) + " " + myOrder.currencyCode)
                        .font(.poppinsFont(size: 16, weight: .bold))
                        .foregroundColor(Color.accentColor)
                }
                
                HStack{
                    Text(myOrder.formattedDate ?? "")
                        .font(.poppinsFont(size: 16, weight: .regular))
                        .foregroundColor(Color.accentColor)
                    
                    Text(myOrder.formattedTime ?? "")
                        .font(.poppinsFont(size: 16, weight: .regular))
                        .foregroundColor(Color.accentColor)
                }
                
                if !isHistory{
                    HStack{
                        Button {
                            self.viewModel.selectedOrderID = myOrder.id
                        } label: {
                            Text("Track order")
                                .frame(maxWidth: .infinity, maxHeight: 45)
                                .font(.poppinsFont(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .background(Color.accentColor)
                                .cornerRadius(12)
                        }
                        .contentShape(Rectangle())
                        
                        Button {
                        } label: {
                            Text("Cancel order")
                                .frame(maxWidth: .infinity, maxHeight: 45)
                                .font(.poppinsFont(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                                .background(Color(hex: 0x0EFAA7C, opacity: 0.3))
                                .cornerRadius(12)
                        }
                        .contentShape(Rectangle())
                        
                    }.frame(maxWidth: .infinity)
                        .padding(5)
                }
                
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .cardBackground()
    }
    
}
