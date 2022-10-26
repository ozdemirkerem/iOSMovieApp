//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Kerem Özdemir on 22.10.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SplashScreen")
        
        let nav = UINavigationController(rootViewController: initialViewController)
        self.window?.rootViewController = nav
        self.window?.addSubview(nav.view)
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

