//
//  AppDelegate.swift
//  TEA-Movie-UiKit
//
//  Created by KhaleD HuSsien on 14/08/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        window.rootViewController = homeNav
        window.makeKeyAndVisible()
        self.window = window
        return true
    }


}

