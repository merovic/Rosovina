//
//  OrderTrackingView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 10/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class OrderTrackingView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: MyOrderDetailsViewModel?
    
    private let loadingView = LoadingAnimation()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var orderIDView: UIView! {
        didSet {
            orderIDView.rounded()
        }
    }
    
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var orderDateView: UIView! {
        didSet {
            orderDateView.rounded()
        }
    }
    
    @IBOutlet weak var orderDateLabel: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var confirmedImage: UIImageView!
    @IBOutlet weak var confirmedDate: UILabel!
    @IBOutlet weak var confirmedTime: UILabel!
    
    @IBOutlet weak var processingImage: UIImageView!
    @IBOutlet weak var processingDate: UILabel!
    @IBOutlet weak var processingTime: UILabel!
    
    @IBOutlet weak var shippingImage: UIImageView!
    @IBOutlet weak var shippingDate: UILabel!
    @IBOutlet weak var shippingTime: UILabel!
    
    @IBOutlet weak var deliveredImage: UIImageView!
    @IBOutlet weak var deliveredDate: UILabel!
    @IBOutlet weak var deliveredTime: UILabel!
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var productsContainer: UIView!
    
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.productsContainer.EmbedSwiftUIView(view: OrderTrackingSwiftUIView(viewModel: viewModel!), parent: self)
    }
    
    func BindViews(){
        
        viewModel!.$isAnimating
            .receive(on: DispatchQueue.main)
            .assign(to: \.isVisible, on: loadingView)
            .store(in: &bindings)
        
        backButton.tapPublisher
            .sink { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &bindings)
        
        viewModel!.$selectedItem.sink { item in
            if item != nil {
                let newViewController = ReviewView()
                newViewController.viewModel = AddReviewViewModel(item: item!)
                self.navigationController?.pushViewController(newViewController, animated: true)
            }
        }.store(in: &bindings)
        
        viewModel!.$myOrder.sink { order in
            if order != nil {
                self.orderIDLabel.text = order?.code
                self.orderDateLabel.text = order?.estimateDeliveryTime
                
                if order?.activities.count == 1{
                    self.statusImage.image = UIImage(named: "first-level")
                    
                    self.confirmedDate.text = order?.activities[0].formattedDate
                    self.confirmedTime.text = order?.activities[0].formattedTime
                }
                
                if order?.activities.count == 2{
                    self.statusImage.image = UIImage(named: "second-level")
                    
                    self.processingDate.isHidden = false
                    self.processingTime.isHidden = false
                    
                    self.processingImage.image = UIImage(named: "orderConfirmed")
                    
                    self.processingDate.text = order?.activities[1].formattedDate
                    self.processingTime.text = order?.activities[1].formattedTime
                }
                
                if order?.activities.count == 3{
                    self.statusImage.image = UIImage(named: "third-level")
                    
                    self.shippingDate.isHidden = false
                    self.shippingTime.isHidden = false
                    
                    self.processingImage.image = UIImage(named: "orderConfirmed")
                    self.shippingImage.image = UIImage(named: "orderShippedOn")
                    
                    self.shippingDate.text = order?.activities[2].formattedDate
                    self.shippingTime.text = order?.activities[2].formattedTime
                }
                
                if order?.activities.count == 4{
                    self.statusImage.image = UIImage(named: "fourth-level")
                    
                    self.deliveredDate.isHidden = false
                    self.deliveredDate.isHidden = false
                    
                    self.processingImage.image = UIImage(named: "orderConfirmed")
                    self.shippingImage.image = UIImage(named: "orderShippedOn")
                    self.deliveredImage.image = UIImage(named: "orderDeliveredOn")
                    
                    self.deliveredDate.text = order?.activities[3].formattedDate
                    self.deliveredTime.text = order?.activities[3].formattedTime
                }
                
                self.totalCount.text = String(order?.itemsCount ?? 1)
                self.totalPrice.text = String(order?.total ?? 0) + " " + (order?.currencyCode ?? "SAR")
                self.paymentMethod.text = order?.paymentMethodName
                self.containerHeight.constant = CGFloat((order?.itemsCount ?? 1) * 180)
            }
        }.store(in: &bindings)
    }

}


struct OrderTrackingSwiftUIView: View {
    
    @ObservedObject var viewModel: MyOrderDetailsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(self.viewModel.myOrder?.items ?? []) { item in
                OrderTrackingItemSwiftUIView(orderItem: item)
                    .onTapGesture {
                        self.viewModel.selectedItem = item
                    }
            }
        }
    }
}


struct OrderTrackingItemSwiftUIView: View {
        
    var orderItem: MyOrderItem
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: orderItem.imageURL))
                .placeholder(Image("logo").resizable())
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(10)
                .frame(width: 60, height: 60)
                .padding(8)
            
            VStack(alignment: .leading){
                HStack {
                    Text(orderItem.productName)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .font(.poppinsFont(size: 14, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                    
                    Text(String(orderItem.quantity) + "x")
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .frame(width: 22, height: 22, alignment: .center)
                        .font(.poppinsFont(size: 12, weight: .medium))
                        .foregroundColor(Color("TextGray"))
                        .background(Color("BackgroundGray"))
                        .cornerRadius(7)
                        .padding(.horizontal, 20)
                }.padding(.top, 5)
                
                Text(String(orderItem.total) + " " + (orderItem.currencyCode ?? "SAR"))
                    .font(.poppinsFont(size: 12, weight: .medium))
                    .foregroundColor(Color.gray)
            }
        
        }.background(
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("LightGray"))
        )

    }
    
}
