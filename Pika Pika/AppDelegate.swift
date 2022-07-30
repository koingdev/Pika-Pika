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
    private lazy var authViewModel = AuthenticationViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
        
        // Root
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Check previous session
        if authViewModel.isLoggedIn() {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = LoginViewController(viewModel: authViewModel)
        }
        window?.makeKeyAndVisible()
        
        return true
    }


}

