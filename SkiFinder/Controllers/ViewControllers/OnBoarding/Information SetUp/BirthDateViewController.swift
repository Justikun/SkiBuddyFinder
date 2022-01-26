//
//  BirthDateViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import UIKit

class BirthDateViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    var user: User?
    let datePicker = UIDatePicker()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        birthDateTextField.delegate = self
        birthDateTextField.becomeFirstResponder()
        createAgeDatePicker()
        
        continueButton.isEnabled = false
        
        setUpStyles()
    }
    
    // MARK: - Actions
    @IBAction func continueButtonPressed(_ sender: UIButton) {

        guard let user = user,
              let birthDate = birthDateTextField.text,
              let formattedDate = DateFormatter().formatter.date(from: birthDate) else { return }
        
        user.birthDate = formattedDate
                
        performSegue(withIdentifier: "toSkiPassLocationVC", sender: user)
    }
    
    
    // MARK: - Methods
    private func setUpStyles() {
        birthDateTextField.setPillShape()
        birthDateTextField.setLeftPaddingPoints()
        
        continueButton.setPillShape()
        continueButton.setShadow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSkiPassLocationVC" {
            guard let destination = segue.destination as? SkiPassLocationViewController,
                  let user = sender as? User else { return }
            
            destination.user = user
        }
    }
    
} // End of class

extension BirthDateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Checks if there is at least 1 character in the text field
        guard let oldText = textField.text else { return false }
            
        // continueButton will be disabled if there are no characters in the text field
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        continueButton.isEnabled = !newText.isEmpty
        return true
    }
} // End of extension


extension BirthDateViewController {
    private func createAgeDatePicker() {
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
        birthDateTextField.inputView = datePicker
        birthDateTextField.inputAccessoryView = toolBar
    }
    
    @objc
    private func ageDoneTapped() {
        continueButton.isEnabled = true
        birthDateTextField.text = DateFormatter().formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
