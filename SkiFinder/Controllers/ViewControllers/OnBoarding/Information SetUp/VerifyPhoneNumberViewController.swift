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
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var vc = UIViewController()
                
                if accountExists {
                    let mainTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController
                    self.view.window?.rootViewController = mainTabBarViewController
                    self.view.window?.makeKeyAndVisible()
                    
                } else {
                    // Add number to numbers in use
                    let mobile = MobileInUse(number: mobileNumber)
                    DatabaseManager.shared.addNumberToMobileNumbers(mobile: mobile) { success in
                        guard success else { return }
                    }
                    vc = storyboard.instantiateViewController(identifier: "ProfileSetUpVC")
                }
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    private func setUpStyles() {
        // continueButton styles
        continueButton.setPillShape()
        continueButton.setShadow()
        continueButton.backgroundColor = .white
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
