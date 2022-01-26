//
//  continueWithPhoneNumberViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/24/22.
//

import UIKit
import Contacts
import NotificationCenter

class ContinueWithPhoneNumberViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    var bottomContinueButtonConstraint = NSLayoutConstraint()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextFieldSetup()
        setUpStyles()
        setUpLoadingIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        phoneNumberTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        loadingIndicator.startAnimating()
        
        guard let phoneNumber = phoneNumberTextField.text else { return }
        
        // Checks to firebase if this is a valid number and sends verification to SMS
        AuthManager.shared.continueWith(phoneNumber: "+1\(phoneNumber)") { success in
            guard success else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Invalid Phone Number", message: "Please enter a valid phone number")
                    self.loadingIndicator.stopAnimating()
                }
                return
            }
            
            DispatchQueue.main.async {
                let verificationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyPhoneNumberVC")
                self.loadingIndicator.stopAnimating()
                self.navigationController?.pushViewController(verificationVC, animated: true)
            }
        }
    }
    
    @IBAction func phoneNumberTextFieldPressed(_ sender: UITextField) {
        self.becomeFirstResponder()
    }
    
    // MARK: - Methods
    private func setUpLoadingIndicator() {
        // Spinner setup
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .black
    }
    private func phoneNumberTextFieldSetup() {
        // Phone Number text field set up
        phoneNumberTextField.delegate = self
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.keyboardType = .numberPad
    }
    
    private func setUpStyles() {
        // Phone Number Style
        phoneNumberTextField.setPillShape()
        phoneNumberTextField.setLeftPaddingPoints(12)
        
        // Country Code Style
        countryCodeButton.setPillShape()
        
        // Continue Button Style
        continueButton.setPillShape()
        continueButton.backgroundColor = .white
        continueButton.titleLabel?.textColor = .label
        continueButton.isEnabled = false
        continueButton.setShadow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoneVerificationVC" {
            guard let destinationVC = segue.destination as? VerifyPhoneNumberViewController else {
                return
            }
        }
    }
    
} // End of class

extension ContinueWithPhoneNumberViewController: UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Checks if there is at least 1 character in the text field
        guard let oldText = textField.text else { return false }
            
        // continueButton will be disabled if there are no characters in the text field
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        continueButton.isEnabled = !newText.isEmpty
        return true
    }
} // End of extension
