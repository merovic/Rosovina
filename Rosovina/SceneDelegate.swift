//
//  SceneDelegate.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/11/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let nav1 = UINavigationController()
        nav1.isNavigationBarHidden = true
        
        if LoginDataService.shared.setFirstLaunchFromTermination(){
            let mainView = OnboardingViewController()
            //nav1.viewControllers = [mainView]
            window?.rootViewController = mainView
            window?.makeKeyAndVisible()
        }else{
            let mainView = DashboardTabBarController()
            nav1.viewControllers = [mainView]
            window?.rootViewController = nav1
            window?.makeKeyAndVisible()
        }
 
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


class ForceUpdateAppVersion {
    class func isForceUpdateRequire(apiVersion:Int) -> Bool {
        
        func update() {
            UserDefaults.standard.set(apiVersion, forKey: "ApiVersion")
        }
        
        func appUpdateAvailable() -> Bool{
            
            guard let info = Bundle.main.infoDictionary,
                let identifier = info["CFBundleIdentifier"] as? String else {
                    return false
            }
            
            let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=\(identifier)&country=sa"
            var upgradeAvailable = false
            // Get the main bundle of the app so that we can determine the app's version number
            let bundle = Bundle.main
            if let infoDictionary = bundle.infoDictionary {
                // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
                let urlOnAppStore = NSURL(string: storeInfoURL)
                if let dataInJSON = NSData(contentsOf: urlOnAppStore! as URL) {
                    // Try to deserialize the JSON that we got
                    if let dict: NSDictionary = try? JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
                        if let results:NSArray = dict["results"] as? NSArray {
                            if let version = (results[0] as! [String:Any])["version"] as? String {
                                //print(results)
                                // Get the version number of the current version installed on device
                                if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                    
                                    var cleanedValue = ""
                                    var foundDecimalPoint = false
                                    
                                    for char in version {
                                        if char == "." && !foundDecimalPoint {
                                            cleanedValue.append(char)
                                            foundDecimalPoint = true
                                        } else if char.isNumber {
                                            cleanedValue.append(char)
                                        }
                                    }
                                    
                                    var cleanedValue2 = ""
                                    var foundDecimalPoint2 = false
                                    
                                    for char in currentVersion {
                                        if char == "." && !foundDecimalPoint2 {
                                            cleanedValue2.append(char)
                                            foundDecimalPoint2 = true
                                        } else if char.isNumber {
                                            cleanedValue2.append(char)
                                        }
                                    }
                                    
                                    if Double(cleanedValue)! > Double(cleanedValue2)! {
                                        upgradeAvailable = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return upgradeAvailable
        }

        let isUpdateRequireed = appUpdateAvailable()
        let apiVersionLocal = UserDefaults.standard.integer(forKey: "ApiVersion")
        guard apiVersionLocal != 0 else {
            update()
            return false
        }
        
        if isUpdateRequireed {
            return true
        } else {
            update()
            return false
        }
        
    }
    
}


extension Bundle {
    public var appName: String           { getInfo("CFBundleName")  }
    public var displayName: String       { getInfo("CFBundleDisplayName")}
    public var language: String          { getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String        { getInfo("CFBundleIdentifier")}
    public var copyright: String         { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String          { getInfo("CFBundleVersion") }
    public var appVersionLong: String    { getInfo("CFBundleShortVersionString") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
