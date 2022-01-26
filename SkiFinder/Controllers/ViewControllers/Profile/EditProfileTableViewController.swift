//
//  EditProfileTableViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/14/22.
//

import UIKit
import Firebase
import Photos
import PhotosUI

class EditProfileTableViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var skiPassTextField: UITextField!
    @IBOutlet weak var skiProficiencyTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var skiSwitch: UISwitch!
    @IBOutlet weak var snowboardSwitch: UISwitch!
    
    // MARK: - Properties
    private let skiProficiencys = ["Expert", "Advanced", "Comfortable", "Novice", "First Timer"]
    private var didChangePhoto = false
    private var profilePhotoURL: String?
    
    var profileUIImage: UIImage?
    
    let datePicker = UIDatePicker()
    let skiProficiencyPicker = UIPickerView()
    var tempBirthDate: Date?
    
    deinit {
        print("----------------")
        print("Deinit")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        createAgeDatePicker()
        setUpSkiProficiencyPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
        
        if let profileUIImage = profileUIImage {
            profilePhoto.image = profileUIImage
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if didChangePhoto {
            savePhoto() {_ in
                self.saveProfile()
            }
        } else {
            self.saveProfile()
        }
    }
    
    @IBAction func changePhotoTapped(_ sender: UIButton) {
        photoPicker()
    }
    // MARK: - Methods
    
    func savePhoto(completion: @escaping(Bool) -> Void) {
        guard let profilePhoto = profilePhoto.image else { return }
        
        UserController.shared.saveProfilePhoto(profilePhoto) {url in
            self.profilePhotoURL = url?.absoluteString
            return completion(true)
        }
        return completion(false)
    }
    
    func saveProfile() {
    
        guard let user = UserController.shared.user,
              let firstName = firstNameTextField.text,
              let birthDate = tempBirthDate else { return }
        
        if didChangePhoto {
            guard let profilePhotoURL = profilePhotoURL else { return }
            user.profilePhotoURL = profilePhotoURL
        }
        
        let skiProficieny = skiProficiencyTextField.text
        let bio = bioTextField.text
        let doesSki = skiSwitch.isOn
        let doesSnowboard = snowboardSwitch.isOn
        let skiPassLocation = skiPassTextField.text
        
        user.firstName = firstName
        user.birthDate = birthDate
        user.skiProficiency = skiProficieny
        user.bio = bio
        user.skiTypes = SkiTypes(ski: doesSki, snowboard: doesSnowboard)
        user.skiPassLocation = skiPassLocation

        UserController.shared.updateUser(user) {[weak self] didUpdate in
            if didUpdate {
                print("Updated User")
                self?.navigationController?.popViewController(animated: true)
            } else {
                print("Could not update User")
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            guard let user = UserController.shared.user else { return }
            
            let firstName = user.firstName
            let bio = user.bio
            let birthDate = user.birthDate
            let doesSki = user.skiTypes.ski
            let doesSnowboard = user.skiTypes.snowboard
            let skiPassLocation = user.skiPassLocation
            let skiProficiency = user.skiProficiency
            
            
            self.firstNameTextField.text = firstName
            self.skiProficiencyTextField.text = skiProficiency
            self.bioTextField.text = bio
            self.tempBirthDate = birthDate
            self.ageTextField.text = "\(birthDate.age)"
            self.skiPassTextField.text = skiPassLocation
            
            doesSki ? self.skiSwitch.setOn(true, animated: false) : self.skiSwitch.setOn(false, animated: false)
            doesSnowboard ? self.snowboardSwitch.setOn(true, animated: false) : self.snowboardSwitch.setOn(false, animated: false)
        }
    }
}

// MARK: - Extensions

extension EditProfileTableViewController {
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
        ageTextField.inputView = datePicker
        ageTextField.inputAccessoryView = toolBar
    }
    
    @objc func ageDoneTapped() {
        tempBirthDate = datePicker.date
        ageTextField.text = "\(datePicker.date.age)"
        self.view.endEditing(true)
    }
    
    @objc func skiProficiencyDoneTapped() {
        self.view.endEditing(true)
    }
} // End of extension

extension EditProfileTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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


extension EditProfileTableViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                }
                
                guard let image = reading as? UIImage else { return }
                DispatchQueue.main.async {
                    self.didChangePhoto = true
                    self.profilePhoto.image = image
                }
            }
        }
    }
    
    func photoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1 // Default
        config.filter = PHPickerFilter.images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
        
    }
}

