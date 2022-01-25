//
//  AppDelegate.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/8/22.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
}
