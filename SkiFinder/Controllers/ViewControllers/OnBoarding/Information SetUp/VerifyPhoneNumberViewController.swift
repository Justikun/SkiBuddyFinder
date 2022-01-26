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
    var window: UIWindow?
    
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
        AuthManager.shared.verifyCode(smsCode: code) { [weak self] success in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            
            guard success else {
                self.showAlert(title: "Invalid Verification Code", message: "The verification code you entered is incorrect. Please try again.")
                return
            }
            
            // Begin onboarding
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ProfileSetUpVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
            
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
