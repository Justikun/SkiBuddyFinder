//
//  AppDelegate.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/8/22.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Asks user for notifications permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { success, _ in
            guard success else { return }
            print("Success in APNS registry")
        }
        
        return true
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Uniquely identify users device and app for notifications
        messaging.token { token, _ in
            guard let token = token else { return }
            print("Token: \(token)")
        }
    }
}

