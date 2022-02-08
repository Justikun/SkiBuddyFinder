//
//  VerifyPhoneNumberViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/24/22.
//

import UIKit

class VerifyPhoneNumberViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var codeTextField: OneTimeCodeTextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var number: String?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStyles()
        setUpLoadingIndicator()
        configureCodeTextField()
    }
    
    // MARK: - Actions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let code = codeTextField.text else { return }
        authenticateCode(code)
    }
    
    // MARK: - Methods
    private func authenticateCode(_ code: String) {
        loadingIndicator.startAnimating()
        guard let mobileNumber = number else { return }

        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            
            guard success else {
                self.showAlert(title: "Invalid Verification Code", message: "The verification code you entered is incorrect. Please try again.")
                return
            }
            
            // Check if account with phone number exists
            DatabaseManager.shared.checkMobile(number: mobileNumber) { [weak self] accountExists in
                guard let self = self else { return }
                
                if accountExists {
                    let mainTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController
                    self.view.window?.rootViewController = mainTabBarViewController
                    self.view.window?.makeKeyAndVisible()
                    
                } else {
                    // Continue to onboarding
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstNameVC") as? FirstNameViewController else { return }
                    let nvc = ProfileSetUpNavigationViewController(rootViewController: vc)
                    
                    self.view.window?.rootViewController = nvc
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    private func setUpStyles() {
        // continueButton styles
        continueButton.setPillShape()
        continueButton.backgroundColor = .white
        continueButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 3.0, opacity: 0.20)
    }
    
    private func setUpLoadingIndicator() {
        // Spinner setup
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .black
    }
    
    private func configureCodeTextField() {
        codeTextField.backgroundColor = .clear
        codeTextField.configure()
        codeTextField.becomeFirstResponder()
        
        codeTextField.didEnterLastDigit = { [weak self] code in
            self?.authenticateCode(code)
        }
    }
}
