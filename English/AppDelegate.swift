//
//  AppDelegate.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainNavigationController = UINavigationController(rootViewController: LoginVC())
        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
        
        self.window = window
        return true
    }



}

