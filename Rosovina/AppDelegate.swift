//
//  AppDelegate.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import UIKit
import MOLH
import Firebase
import IQKeyboardManagerSwift
import SDWebImageSVGCoder
import GooglePlaces
import GoogleMaps
import MFSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GMSPlacesClient.provideAPIKey("AIzaSyCCiAbMIfF_IpdCxFKB7CZTgqbJrlOc09o")
        GMSServices.provideAPIKey("AIzaSyCCiAbMIfF_IpdCxFKB7CZTgqbJrlOc09o")
        
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        
        fontApply()
        
        MOLH.shared.activate(true)
        IQKeyboardManager.shared.enable = true
        
        MOLH.setLanguageTo("en")
        
        MFSettings.shared.configure(token: "jzTV0eXVehJLj2pvkRqj3sfGsO7b9qgCIEJyDtRemYqZLSf9QWYSRT8Ty1xYn7jFQuVTgs52v-BgKKg011RRAclcxYlSfI0VsNlIJFnK9yQE-kfWT3yh2JJuX5hMzzMsTbZjfzcabSMKBC0RvihnjggkcO76kYMgpgjFtuDFsQ1_D-NyBrmHbVtaIWi9VMoOgGPb4dz2CYqhdSMNUmwv9YgzBEQnJa94k2JTlftkL51ClrhT8jeJ1Wt2EAqBGyZH6QH3yPbaFRY1R3gPcKeDl_C5XLgzvgCe2t1MYL-__MTU283sKGfYdOu1wrmf51X0gAW2HHHa15yrmnl6CKiFfMZLb4mdN92OY032hx5ldzh7COjeDiABDrN5Ndu0OVoTIPLBnlvFwswvGNt-cKkt8hahQ6igL1c_eMAvqyiRD-j0SJXvQuRHP6R0DMSj7J4lBAYPsBAXvb5QVY55WJCCcnMkMw8hc8VNfkOHnXaCjSLO2VckR9FI5iJvpx3yk55kCy41h3xTUW0mHNadwa3ISxVgxEEAcvZ14trEVJMs5FjI30uACjEdHw7ZKOLyAY-35ibjfbmxVnyq108UyNXH6Z-ATvA3kixZ2gCUA7LvSeV1yJjqP0FhTY8VhZx51cmE-1cWpRRWRV4_771X3-BwO0pHr12OqQkVehmQMLoaokXY8t3HwwIskKKwREP4mqI09Pnsnw", country: .saudiArabia, environment: .live)

        // you can change color and title of navigation bar
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: UIColor.init(named: "AccentColor")!, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
        MFSettings.shared.setTheme(theme: them)
        
        return true
    }
    
    func fontApply(){
        UILabel.appearance().substituteFontName = "Poppins"
        UITextView.appearance().substituteFontName = "Poppins"
        UITextField.appearance().substituteFontName = "Poppins"
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

