//
//  OnboardingViewController.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import UIKit
import SwiftUI

class OnboardingViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var getStartedButton: UIButton! { didSet { getStartedButton.rounded()}}
    
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        AttachViews()
    }
    
    func AttachViews() {
        self.container.EmbedSwiftUIView(view: OnboardingSwiftUIView(), parent: self)
    }

    @IBAction func getStartedClicked(_ sender: Any) {
        let nav1 = UINavigationController()
        let vc = InitCountryView()
        nav1.isNavigationBarHidden = true
        nav1.viewControllers = [vc]
        nav1.modalPresentationStyle = .fullScreen
        self.present(nav1, animated: true)
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        let nav1 = UINavigationController()
        let vc = DashboardTabBarController()
        nav1.isNavigationBarHidden = true
        nav1.viewControllers = [vc]
        nav1.modalPresentationStyle = .fullScreen
        self.present(nav1, animated: true)
    }
}


struct OnboardingSwiftUIView: View {
    
    var imageNames = ["flower1", "flower2", "flower3", "flower4"]
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<imageNames.count, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
//            HStack(spacing: 10) {
//                ForEach(0..<imageNames.count, id: \.self) { index in
//                    Circle()
//                        .frame(width: 8, height: 8)
//                        .foregroundColor(index == currentPage ? .white : .gray)
//                }
//            }
        }
    }
}

