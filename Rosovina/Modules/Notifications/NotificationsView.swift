//
//  NotificationsView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import SwiftUI
import SDWebImageSwiftUI
import Combine
import CombineCocoa

class NotificationsView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: NotificationsViewModel = NotificationsViewModel()
    
    private let loadingView = LoadingAnimation()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: NotificationsSwiftUIView(viewModel: self.viewModel), parent: self)
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

struct NotificationsSwiftUIView: View {
    
    @ObservedObject var viewModel: NotificationsViewModel
    
    var body: some View {
        ZStack(alignment: .center){
            if self.viewModel.notificationsList.count > 0{
                ScrollView(.vertical, showsIndicators: false){
                    ForEach(self.viewModel.notificationsList) { item in
                        NotificationsitemSwiftUIView(notification: item)
                    }
                }
            }else{
                VStack{
                    Text("Notifications List is Empty")
                        .font(.poppinsFont(size: 25, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    Spacer().frame(height: 300)
                }
            }
        }
        
    }
    
}

struct NotificationsitemSwiftUIView: View {
    
    var notification: NotificationItem
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    Circle()
                        .fill(Color("AccentColor"))
                        .frame(width: 6, height: 6)
                    
                    Text(notification.title)
                        .font(.poppinsFont(size: 16, weight: .bold))
                        .foregroundColor(Color.black)
                    Spacer()
                }
                
                Text(notification.body)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .font(.poppinsFont(size: 14, weight: .regular))
                    .foregroundColor(Color.gray)
                
                HStack{
                    Text(notification.createdAt)
                        .font(.poppinsFont(size: 14, weight: .regular))
                        .foregroundColor(Color.gray)
                    
//                    Text("12/12/2021")
//                        .font(.poppinsFont(size: 14, weight: .regular))
//                        .foregroundColor(Color.gray)
                }
                
            }.padding(.horizontal, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .cardBackground()
    }
}
