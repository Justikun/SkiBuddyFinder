//
//  MainTabBarViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.fetchCurrentUser { _ in }
    }
}
