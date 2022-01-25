//
//  SignInViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/11/22.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        guard let emailText = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let passwordText = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { result, error in
            if let error = error {
                self.handleError(error)
            } else {
                self.transitionToMainTabBarVC()
            }
        }
    }
    
    // MARK: - Methods
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
//            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Incorrect Password", message: errorCode.errorMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func transitionToMainTabBarVC() {
        let mainTabBarViewController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.mainTabBarVC) as? MainTabBarViewController
        
        view.window?.rootViewController = mainTabBarViewController
        view.window?.makeKeyAndVisible()
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
