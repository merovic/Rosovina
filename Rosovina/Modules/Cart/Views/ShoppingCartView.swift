//
//  ShoppingCartView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class ShoppingCartView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: CartViewModel = CartViewModel()
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var placeholderView: UIStackView!
    
    @IBOutlet weak var startAddingButton: UIButton! {
        didSet {
            startAddingButton.prettyHareefButton(radius: 16)
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var checkOutButton: UIButton! {
        didSet {
            checkOutButton.prettyHareefButton(radius: 16)
        }
    }
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: ShoppingCartSwiftUIView(viewModel: self.viewModel), parent: self)
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
        
        startAddingButton.tapPublisher
            .sink { _ in
                let nav1 = UINavigationController()
                let vc = DashboardTabBarController()
                nav1.isNavigationBarHidden = true
                nav1.viewControllers = [vc]
                nav1.modalPresentationStyle = .fullScreen
                self.present(nav1, animated: true)
            }
            .store(in: &bindings)
        
        checkOutButton.tapPublisher
            .sink { _ in
                if LoginDataService.shared.isLogedIn(){
                    let newViewController = OrderCustomizeView()
                    newViewController.viewModel = OrderCustomizeViewModel(cartResponse: self.viewModel.cartResponse!)
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }else {
                    let newViewController = NeedLoginView()
                    newViewController.showBackButton = true
                    self.navigationController?.pushViewController(newViewController, animated: true)
                }
            }
            .store(in: &bindings)
        
        viewModel.$errorMessage.sink { response in
            if response != ""{
                Alert.show("PromoCode Error", message: response, context: self)
            }
        }.store(in: &bindings)
        
        viewModel.$cartResponse.sink { response in
            if response != nil{
                if response!.itemsQuantity > 0{
                    self.placeholderView.isHidden = true
                    self.container.isHidden = false
                    self.checkOutButton.isHidden = false
                }else{
                    self.placeholderView.isHidden = false
                    self.container.isHidden = true
                    self.checkOutButton.isHidden = true
                }
            }
        }.store(in: &bindings)
    }
}

struct ShoppingCartSwiftUIView: View {
    
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ForEach(self.viewModel.cartResponse?.items ?? []) { cartItem in
                ShoppingCartItemSwiftUIView(viewModel: viewModel, cartItem: cartItem)
            }
            
            VStack(alignment: .leading){
                Text("Add coupon")
                    .font(.poppinsFont(size: 16, weight: .bold))
                    .foregroundColor(Color.black)
                
                HStack(spacing: 5){
                    TextField("Enter voucher code", text: $viewModel.promocodeText)
                        .font(.poppinsFont(size: 12, weight: .regular))
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color("LightGray"), style: StrokeStyle(lineWidth: 1.0)))
                    
                    Spacer()
                    
                    Button {
                        self.viewModel.checkPromoCode()
                    } label: {
                        Text("Apply")
                            .font(.poppinsFont(size: 12, weight: .regular))
                            .frame(width: 65, height: 15)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("AccentColor"))
                            .cornerRadius(15)
                    }
                }
                
                VStack{
                    HStack{
                        Text("Total items")
                            .font(.poppinsFont(size: 12, weight: .regular))
                            .foregroundColor(Color("DarkGray"))
                        Spacer()
                        Text(String(viewModel.cartResponse?.itemsQuantity ?? 0))
                            .font(.poppinsFont(size: 12, weight: .bold))
                            .foregroundColor(Color("AccentColor"))
                    }.padding()
                    
                    HStack{
                        Text("Price")
                            .font(.poppinsFont(size: 12, weight: .regular))
                            .foregroundColor(Color("DarkGray"))
                        Spacer()
                        Text(String(viewModel.cartResponse?.subTotal ?? 0) + " " + (viewModel.cartResponse?.currencyCode ?? "SAR"))
                            .font(.poppinsFont(size: 12, weight: .bold))
                            .foregroundColor(Color("AccentColor"))
                    }.padding(.horizontal)
                    
                    HStack{
                        Text("Discount")
                            .font(.poppinsFont(size: 12, weight: .regular))
                            .foregroundColor(Color("DarkGray"))
                        Spacer()
                        Text(String(viewModel.cartResponse?.discountPercentage ?? 0) + " " + (viewModel.cartResponse?.currencyCode ?? "SAR"))
                            .font(.poppinsFont(size: 12, weight: .bold))
                            .foregroundColor(Color("AccentColor"))
                    }.padding()
                    
                    Divider().frame(width: .infinity).padding(.horizontal)
                    
                    HStack{
                        Text("Total price")
                            .font(.poppinsFont(size: 12, weight: .regular))
                            .foregroundColor(Color("DarkGray"))
                        Spacer()
                        Text(String(viewModel.cartResponse?.total ?? 0) + " " + (viewModel.cartResponse?.currencyCode ?? "SAR"))
                            .font(.poppinsFont(size: 12, weight: .bold))
                            .foregroundColor(Color("AccentColor"))
                    }.padding()
                }.background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("LightGray"))
                )
            }
        }
    }
}


struct ShoppingCartItemSwiftUIView: View {
    
    @ObservedObject var viewModel: CartViewModel
    
    var cartItem: CartItem
    
    @State
    var itemQuantity: Int = 1
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: cartItem.productImage))
                .placeholder(Image("logo").resizable())
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(10)
                .frame(width: 80, height: 80)
                .padding(.leading, 12)
            
            VStack(alignment: .leading){
                HStack {
                    Text(cartItem.productName)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .font(.poppinsFont(size: 14, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text("Flowers")
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .frame(height: 20, alignment: .center)
                        .font(.poppinsFont(size: 12, weight: .medium))
                        .foregroundColor(Color.gray)
                        .padding(.horizontal)
                }.padding(.top, 5)
                
                Text(String(cartItem.total) + " " + (cartItem.currencyCode ?? "SAR"))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .font(.poppinsFont(size: 12, weight: .medium))
                    .foregroundColor(Color.gray)
                
                HStack{
                    HStack{
                        Button {
                            if self.itemQuantity > 1{
                                self.itemQuantity -= 1
                                self.viewModel.cartResponse!.items[self.getItemIndexById(cartItem.productID)].quantity = String(self.itemQuantity)
                                self.viewModel.updateCart()
                                //self.viewModel.updateArray(withProductID: item.productID, forValue: self.itemQuantity)
                            }
                        } label: {
                            Image("Minus")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        
                        Text(String(itemQuantity))
                            .frame(height: 27, alignment: .center)
                            .font(.poppinsFont(size: 12, weight: .medium))
                            .foregroundColor(Color.black)
                            .padding(.horizontal,10)
                            .padding(.vertical,5)
                        Button {
                            self.itemQuantity += 1
                            self.viewModel.cartResponse!.items[self.getItemIndexById(cartItem.productID)].quantity = String(self.itemQuantity)
                            self.viewModel.updateCart()
                            //self.viewModel.updateArray(withProductID: item.productID, forValue: self.itemQuantity)
                        } label: {
                            Image("Add")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        
                    }.overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("LightGray"), lineWidth: 1.0)
                    )
                    Spacer()
                    Image("Bin")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.horizontal)
                        .onTapGesture {
                            self.viewModel.cartResponse!.items.remove(at: self.getItemIndexById(cartItem.productID))
                            self.viewModel.updateCart()
                        }
                }
            }.onAppear{
                self.itemQuantity = Int(Double(self.cartItem.quantity) ?? 0.0)
            }
        
        }.background(
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("LightGray"))
        )

    }
    
    func getItemIndexById(_ id: Int) -> Int {
        if let index = self.viewModel.cartResponse!.items.firstIndex(where: { $0.productID == id }) {
            return index
        }
        return 0
    }
    
}
