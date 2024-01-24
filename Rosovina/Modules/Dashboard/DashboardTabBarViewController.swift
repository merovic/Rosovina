//
//  DashboardTabBarViewController.swift
//  Rosovina
//
//  Created by Amir Ahmed on 06/01/2024.
//

import UIKit

class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var middleButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        middleButton?.center.y = tabBar.bounds.height - 30 - tabBar.safeAreaInsets.bottom
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isLoggiedIn = LoginDataService.shared.isLogedIn()
        
        let item1 = HomeViewController()
        let icon1 = UITabBarItem(title: "", image: UIImage(named: "home.png"), selectedImage: UIImage(named: "otherImage.png"))
        item1.tabBarItem = icon1
        
        let item2 = isLoggiedIn ? MyOrdersView() : NeedLoginView()
        let icon2 = UITabBarItem(title: "", image: UIImage(named: "bill 1.png"), selectedImage: UIImage(named: "otherImage.png"))
        item2.tabBarItem = icon2
        
        let item0 = DummyViewController()
        let icon0 = UITabBarItem(title: "", image: nil, selectedImage: nil)
        item0.tabBarItem = icon0
        
        let item3 = isLoggiedIn ? WishlistView() : NeedLoginView()
        let icon3 = UITabBarItem(title: "", image: UIImage(named: "favorite 1.png"), selectedImage: UIImage(named: "otherImage.png"))
        item3.tabBarItem = icon3
        
        let item4 = isLoggiedIn ? ProfileView() : NeedLoginView()
        let icon4 = UITabBarItem(title: "", image: UIImage(named: "profile 1.png"), selectedImage: UIImage(named: "otherImage.png"))
        item4.tabBarItem = icon4
        
        let controllers = [item1, item2, item0, item3, item4]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        middleButton?.removeFromSuperview()
        middleButton = nil
        
        if middleButton == nil {
            
            middleButton = UIButton(type: .custom)
            middleButton?.frame.size = CGSize(width: 120, height: 120)
            middleButton?.center = CGPoint(x: tabBar.bounds.width / 2, y: tabBar.bounds.height - 30)
            middleButton?.setImage(UIImage(named: "center-button"), for: .normal)
            middleButton?.layer.cornerRadius = middleButton!.frame.height / 2
            middleButton?.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
            
            tabBar.addSubview(middleButton!)
        }
        
        tabBar.backgroundColor = UIColor.white
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return viewController != self.viewControllers?[2]
    }
    
    @objc func middleButtonTapped() {
        if LoginDataService.shared.isLogedIn(){
            let newViewController = ShoppingCartView()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }else {
            let newViewController = NeedLoginView()
            newViewController.showBackButton = true
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}

class DummyViewController: UIViewController {
    // This is a dummy view controller that does nothing
}
