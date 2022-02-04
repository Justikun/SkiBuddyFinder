//
//  FirstNameViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import UIKit

class FirstNameViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        
        setUpStyles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        UIView.setAnimationsEnabled(false)
    }
    
    // MARK: - Actions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let firstName = nameTextField.text,
              let uid = AuthManager.shared.auth.currentUser?.uid else { return }
        
        let user = User(uid: uid, firstName: firstName)
        
        performSegue(withIdentifier: "toBirthDateVC", sender: user)
    }
    
    
    // MARK: - Methods
    private func setUpStyles() {
        nameTextField.setPillShape()
        nameTextField.setLeftPaddingPoints()
        
        continueButton.setPillShape()
        continueButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 3.0, opacity: 0.20)
        continueButton.isEnabled = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBirthDateVC" {
            guard let destination = segue.destination as? BirthDateViewController,
                  let user = sender as? User else { return }
    
            destination.user = user
        }
    }
} // End of class


extension FirstNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Checks if there is at least 1 character in the text field
        guard let oldText = textField.text else { return false }
            
        // continueButton will be disabled if there are no characters in the text field
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        continueButton.isEnabled = !newText.isEmpty
        return true
    }
}
