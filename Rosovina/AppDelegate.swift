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

