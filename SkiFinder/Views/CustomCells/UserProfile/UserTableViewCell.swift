//
//  UserTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/10/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var skillProficiencyLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    // MARK: - Methods
    func updateViews() {
        guard let user = user else { return }
        
        nameAgeLabel.text = "\(user.firstName)"
        styleLabel.text = "(Snowboard)"
        bioLabel.text = user.bio
        skillProficiencyLabel.text = user.skiProficiency
        
        updateAndSetImage()
    }
    
    func updateAndSetImage() {
        guard let userImageURLString = user?.profilePhotoURL else { return }
        AllUsersController.shared.getUIImage(for: userImageURLString) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.userImage.image = image                    
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLookAndFeel()
    }
    
} // End of class


// MARK: - Extensions
// Design
extension UserTableViewCell {
    func updateLookAndFeel() {
        skillProficiencyLabel.layer.cornerRadius = CGFloat(roundf(Float(self.skillProficiencyLabel.frame.size.height/2.0)))
        skillProficiencyLabel.layer.masksToBounds = true
    }
}
