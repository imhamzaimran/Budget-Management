//
//  AppDelegate.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize Google sign-in
        
        createDirectory()
//        checkUserLoggedIn()
        GIDSignIn.sharedInstance().clientID = "117501428831-i2g7aivm9tj0dmlve0pb6i6i85tkafhv.apps.googleusercontent.com"
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url)
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



extension AppDelegate {
    
    private func createDirectory(){
        let docDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        
        if let docDirPath = docDirPath {
            //            let directoryPath = docDirPath.appending("/Avengers Assemble")
            print(docDirPath)
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: docDirPath) {
                do {
                    try fileManager.createDirectory(atPath: docDirPath, withIntermediateDirectories: false, attributes: nil)
                    
                    print("Directory creation successfull.")
                } catch {
                    print("Error Creating Directory: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func checkUserLoggedIn(){
//        let controller = UIStoryboard(name: "Main", bundle: nil)
//        let loginVC = controller.instantiateViewController(identifier: Constants.StoryboardIDs.login) as! LoginPageViewController
//        let dasboardVC = controller.instantiateViewController(identifier: Constants.StoryboardIDs.dashboard) as! DashBoard
//
//
//        if GIDSignIn.sharedInstance()?.currentUser != nil {
//            print("Logged in...")
//            self.window?.rootViewController = loginVC
//
//        } else {
//            print("Not Logged in...")
//            self.window?.rootViewController = dasboardVC
//        }
        
//        if let navigationController = self.window?.rootViewController as? UINavigationController {
//            navigationController.pushViewController(dasboardVC, animated: true)
//        } else {
//            print("Navigation Controller not found!")
//        }
        
        
//        if let window = self.window, let rootViewController = window.rootViewController {
//            var currentController = rootViewController
//
//            while let presentedController = currentController.presentedViewController {
//                currentController = presentedController
//            }
//            currentController.present(navController, animated: true, completion: nil)
//        }
    }
    
   
}
