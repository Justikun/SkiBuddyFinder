//
//  RegisterViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/9/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    
    // MARK: - Properties
    var datePicker = UIDatePicker()
    var tempBirthDate: Date?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        dateOfBirthTextField.delegate = self
        
//        addStateDidChangeListener()
        createAgeDatePicker()
    }
    
    // MARK: - Actions
    @IBAction func signUpButtonPressed(_ sender: Any) {
    
    // Authenticate User Creation
        signUpWithEmail()

    }

    // MARK: - Methods
    func addStateDidChangeListener() {
        Auth.auth().addStateDidChangeListener { auth, user in

        }
        
    }
    
    func signUpWithEmail() {
        guard let firstName = firstNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmedPassword = confirmPasswordTextField.text,
              let dob = dateOfBirthTextField.text,
              let tempBirthDate = tempBirthDate,
              !firstName.isEmpty,
              !email.isEmpty,
              !dob.isEmpty else {
                  handleError(message: "Not all fields are filled out")
                  return
              }
        
        if check(password: password, sameAs: confirmedPassword) {
            UserController.shared.signUpUser(withEmail: email, password: password) { result in
                switch result {
                    
                case .success(let authResult):
                    let userUID = authResult.user.uid
                    let newUser = User(uid: userUID, firstName: firstName, birthDate: tempBirthDate)
                    UserController.shared.createUserInFirebase(user: newUser) { error in
                        if let error = error {
                            self.handleError(error)
                        } else {
                            self.transitionToMainTabBarVC()
                        }
                    }
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func check(password: String, sameAs confirmedPassword: String) -> Bool {
        // Same
        if password != confirmedPassword {
            let message = "Passwords don't match"
            handleError(message: message)
            return false
        }
        
        return true
    }
    
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
//            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okaAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okaAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func transitionToMainTabBarVC() {
        let mainTabBarViewController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.mainTabBarVC) as? MainTabBarViewController
        
        view.window?.rootViewController = mainTabBarViewController
        view.window?.makeKeyAndVisible()
    }
    
    func createAgeDatePicker() {
        // Tool bar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // Space so it pushes the Done button to the right
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // Done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(ageDoneTapped))
        
        // Datepicker options
        toolBar.setItems([flexBarButton, doneButton], animated: true)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.inputAccessoryView = toolBar
    }
    
    @objc func ageDoneTapped() {
        tempBirthDate = datePicker.date
        dateOfBirthTextField.text = "\(datePicker.date.age)"
        self.view.endEditing(true)
    }
} // End of class

// MARK: - Extensions
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
