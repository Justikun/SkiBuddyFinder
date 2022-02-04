//
//  addProfilePicViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import UIKit
import PhotosUI

class AddProfilePicViewController: UIViewController {
    
    // MARK: - Outles
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    // MARK: - Properties
    var user: User?
    
    private var didChangePhoto = false
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.setAnimationsEnabled(true)
        continueButton.isEnabled = false
        setUpStyles()
    }
    
    // MARK: - Actions
    @IBAction func changeProfilePhotoButtonPressed(_ sender: UIButton) {
        // TODO: - add Image cropper SDK to this.
        photoPicker()
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let user = user,
              let profileImage = profileImage.image else { return }
        savePhoto(photo: profileImage) { url in
            if let url = url {
                // Saved profile url
                user.profilePhotoURL = url
                
                UserController.shared.createUserInFirebase(user: user) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                    } else {
                        // Transition to Main Nav Bar
                        let mainTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as? MainTabBarViewController
                        self.view.window?.rootViewController = mainTabBarViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    private func setUpStyles() {
        continueButton.setPillShape()
        continueButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 3.0, opacity: 0.20)

    }
    
    private func savePhoto(photo: UIImage, completion: @escaping(String?) -> Void) {
        UserController.shared.saveProfilePhoto(photo) { url in
            return completion(url?.absoluteString)
        }
        return completion(nil)
    }
} // End of class

extension AddProfilePicViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] reading, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                }
                
                guard let image = reading as? UIImage else { return }
                DispatchQueue.main.async {
                    self.continueButton.isEnabled = true
                    self.didChangePhoto = true
                    self.profileImage.image = image
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
