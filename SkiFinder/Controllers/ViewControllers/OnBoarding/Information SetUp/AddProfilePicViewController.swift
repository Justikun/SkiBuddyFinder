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
    private var profilePhotoURL: String?
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.setAnimationsEnabled(true)
        setUpStyles()
    }
    
    // MARK: - Actions
    @IBAction func changeProfilePhotoButtonPressed(_ sender: UIButton) {
        photoPicker()
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        // TODO: - continue to the main app
    }
    
    // MARK: - Methods
    private func setUpStyles() {
        continueButton.setPillShape()
        continueButton.setShadow()
    }
} // End of class

extension AddProfilePicViewController: PHPickerViewControllerDelegate {
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
