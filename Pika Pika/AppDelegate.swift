//
//  AppDelegate.swift
//  Pika Pika
//
//  Created by KoingDev on 29/7/22.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
        
        // Root
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        // Check previous session
        if AuthenticationViewModel.shared.isLoggedIn() {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = LoginViewController()
        }
        window?.makeKeyAndVisible()
        
        return true
    }


}

