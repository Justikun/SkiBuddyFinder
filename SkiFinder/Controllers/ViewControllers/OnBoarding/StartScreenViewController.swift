//
//  StartScreenViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import UIKit

class StartScreenViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var fadeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyles()
    }
    
    private func setUpStyles() {
        // Fade view
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = fadeView.bounds
        gradientLayer.colors = [
            UIColor(red: 196/255, green: 224/255, blue: 255/255, alpha: 0.0).cgColor,
            UIColor(red: 196/255, green: 224/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0.0, 0.3]
        fadeView.layer.insertSublayer(gradientLayer, at: 0
        )

        // Login buttton
        loginButton.setPillShape()
        loginButton.setShadow()
        
//        UIColor(red: 196/255, green: 224/255, blue: 255/255, alpha: 0.90)
        
        // Sign up button
        signUpButton.setPillShape()
        signUpButton.setShadow()
        
    }
}
