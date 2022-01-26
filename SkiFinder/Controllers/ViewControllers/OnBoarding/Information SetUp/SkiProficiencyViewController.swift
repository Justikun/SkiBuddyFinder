//
//  SkiProficiencyViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import UIKit

class SkiProficiencyViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var skiProficiencyTextField: UITextField!
    @IBOutlet weak var skiSwitch: UISwitch!
    @IBOutlet weak var snowboardSwitch: UISwitch!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    var user: User?
    private let skiProficiencyPicker = UIPickerView()
    private let skiProficiencys = ["Expert", "Advanced", "Comfortable", "Novice", "First Timer"]
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        skiProficiencyTextField.becomeFirstResponder()
        setUpSkiProficiencyPicker()
        
        continueButton.isEnabled = false
        
        setUpStyles()
    }
    
    // MARK: - Actions
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let user = user,
              let skiProficiency = skiProficiencyTextField.text else { return }
        user.skiProficiency = skiProficiency
        user.skiTypes.ski = skiSwitch.isOn
        user.skiTypes.snowboard = skiSwitch.isOn
        
        performSegue(withIdentifier: "toAddPhotoVC", sender: user)
    }
    
    
    // MARK: - Methods
    private func setUpStyles() {
        skiProficiencyTextField.setPillShape()
        skiProficiencyTextField.setLeftPaddingPoints()
        
        continueButton.setPillShape()
        continueButton.setShadow()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddPhotoVC" {
            guard let destination = segue.destination as? AddProfilePicViewController,
                  let user = sender as? User else { return }
            
            destination.user = user
        }
    }
} // End of class


// Adding done button to ski profiency picker
extension SkiProficiencyViewController {
    func setUpSkiProficiencyPicker() {
        // Setting Delegate & Datasource
        skiProficiencyPicker.delegate = self
        skiProficiencyPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // Space so it pushes the Done button to the right
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // Done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(skiProficiencyDoneTapped))
        
        toolBar.setItems([flexBarButton, doneButton], animated: true)
        skiProficiencyTextField.inputAccessoryView = toolBar
        skiProficiencyTextField.inputView = skiProficiencyPicker
    }
    
    @objc func skiProficiencyDoneTapped() {
        continueButton.isEnabled = true
        self.view.endEditing(true)
    }
} // End of extension


// Set up for Ski Proficiency picker
extension SkiProficiencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return skiProficiencys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return skiProficiencys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        skiProficiencyTextField.text = skiProficiencys[row]
    }
    
} // End of extension
