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
        
        guard let basePhoneNumber = phoneNumberTextField.text else { return }
        let phoneNumber = "+1\(basePhoneNumber)"
        
        // Checks to firebase if this is a valid number and sends verification to SMS
        AuthManager.shared.continueWith(phoneNumber: phoneNumber) {[weak self] success in
            guard let self = self else { return }
        
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toVerifyPhoneNumberVC", sender: phoneNumber)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Invalid Phone Number", message: "Please enter a valid phone number")
                    self.loadingIndicator.stopAnimating()
                }
                return
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
        if segue.identifier == "toVerifyPhoneNumberVC" {
            guard let destinationVC = segue.destination as? VerifyPhoneNumberViewController,
                  let number = sender as? String else { return }
            destinationVC.number = number
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
