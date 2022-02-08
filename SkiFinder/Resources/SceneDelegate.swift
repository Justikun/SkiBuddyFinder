//
//  SceneDelegate.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/8/22.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        
        // if user IS logged in and has completed onboarding
        if Auth.auth().currentUser != nil {
            if let mobileNumber = Auth.auth().currentUser?.phoneNumber {
                DatabaseManager.shared.checkMobile(number: mobileNumber) {[weak self] numberExists in
                    // If number exists this means user has finished onboarding
                    if numberExists {
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarViewController")
                        DispatchQueue.main.async {
                            self?.window?.rootViewController = mainTabBarController
                            self?.window?.makeKeyAndVisible()
                        }
                    } else {
                        // User needs to complete onboarding
                        guard let vc = storyboard.instantiateViewController(withIdentifier: "FirstNameVC") as? FirstNameViewController else { return }
                        let nvc = ProfileSetUpNavigationViewController(rootViewController: vc)
                        DispatchQueue.main.async {
                            self?.window?.rootViewController = nvc
                            self?.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        } else { // if user is NOT logged in
            let loginNavController = storyboard.instantiateViewController(identifier: "OnBoardingNavigationVC")
            window?.rootViewController = loginNavController
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

