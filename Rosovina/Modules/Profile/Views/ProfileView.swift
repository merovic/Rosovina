//
//  ProfileView.swift
//  Rosovina
//
//  Created by Amir Ahmed on 11/11/2023.
//

import UIKit
import Combine
import SDWebImage
import BottomSheet

class ProfileView: UIViewController {
    
    private var bindings = Set<AnyCancellable>()
    
    var viewModel: ProfileViewModel = ProfileViewModel()
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.makeRounded()
        }
    }
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    var profileGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var notificationsGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var settingsGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var myOrdersGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var walletGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var favoriteGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var supportGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    var logoutGest: UITapGestureRecognizer = {
        let gest = UITapGestureRecognizer()
        gest.numberOfTapsRequired = 1
        return gest
    }()
    
    @IBOutlet weak var myProfileView: UIView! {
        didSet {
            myProfileView.isUserInteractionEnabled = true
            myProfileView.addGestureRecognizer(profileGest)
        }
    }
    
    @IBOutlet weak var notificationsView: UIView! {
        didSet {
            notificationsView.isUserInteractionEnabled = true
            notificationsView.addGestureRecognizer(notificationsGest)
        }
    }
    
    @IBOutlet weak var settingsView: UIView! {
        didSet {
            settingsView.isUserInteractionEnabled = true
            settingsView.addGestureRecognizer(settingsGest)
        }
    }
    
    @IBOutlet weak var myOrdersview: UIView! {
        didSet {
            myOrdersview.isUserInteractionEnabled = true
            myOrdersview.addGestureRecognizer(myOrdersGest)
        }
    }
    
    @IBOutlet weak var walletView: UIView! {
        didSet {
            walletView.isUserInteractionEnabled = true
            walletView.addGestureRecognizer(walletGest)
        }
    }
    
    @IBOutlet weak var favoriteView: UIView! {
        didSet {
            favoriteView.isUserInteractionEnabled = true
            favoriteView.addGestureRecognizer(favoriteGest)
        }
    }
    
    @IBOutlet weak var supportView: UIView! {
        didSet {
            supportView.isUserInteractionEnabled = true
            supportView.addGestureRecognizer(supportGest)
        }
    }
    
    @IBOutlet weak var logoutView: UIView! {
        didSet {
            logoutView.isUserInteractionEnabled = true
            logoutView.addGestureRecognizer(logoutGest)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.profileImage.sd_setImage(with: URL(string: self.viewModel.userImage), placeholderImage: UIImage(named: "user.png"))
        self.userName.text = self.viewModel.userName
        self.userID.text = self.viewModel.userID
    }
    
    func BindViews(){
        
        profileGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = MyProfileView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        notificationsGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = NotificationsView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        settingsGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = SettingsView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        myOrdersGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = MyOrdersView()
                newViewController.showBackButton = true
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        walletGest.tapPublisher
            .sink(receiveValue:{_ in
                
            })
            .store(in: &bindings)
        
        favoriteGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = WishlistView()
                newViewController.showBackButton = true
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        supportGest.tapPublisher
            .sink(receiveValue:{_ in
                let newViewController = ContactusView()
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            .store(in: &bindings)
        
        logoutGest.tapPublisher
            .sink(receiveValue:{_ in
                let vc = SwiftBottomSheet(initialHeight: 300, text1Name: "Are you sure you want to logout ?", text2Name: "", mainIconName: "switch", button1Text: "Yes", button2Text: "Cancel")
                vc.delegate = self
                self.presentBottomSheetInsideNavigationController(
                    viewController: vc,
                    configuration: BottomSheetConfiguration(
                        cornerRadius: 20,
                        pullBarConfiguration: .visible(.init(height: 20)),
                        shadowConfiguration: .init(backgroundColor: UIColor.black.withAlphaComponent(0.6))
                    )
                )
            })
            .store(in: &bindings)
        
//        viewModel.$userImage.sink { v in
//            self.profileImage.sd_setImage(with: URL(string: self.viewModel.userImage), placeholderImage: UIImage(named: "user.png"))
//            self.userName.text = self.viewModel.userName
//            self.userID.text = self.viewModel.userID
//
//        }.store(in: &bindings)
    }

}


extension ProfileView: SwiftBottomSheetDelegate {
    func clickAssigned(buttonNumber: Int) {
        switch buttonNumber{
        case 1:
            self.dismiss(animated: true)
            self.viewModel.logout()
            let vc = LoginView()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            self.dismiss(animated: true)
        default:
            print("")
        }
    }
}
