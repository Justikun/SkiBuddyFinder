//
//  UserProfileTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/18/22.
//

import UIKit

class SkiUserPhotoTableViewCell: UITableViewCell {
    // MARK: - Properties
    var profilePhotoURL: String? {
        didSet {
            getImage()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getImage() {
        guard let profilePhotoURL = profilePhotoURL else { return }

        if let url = URL(string: profilePhotoURL) {
            DispatchQueue.global().async {
                // fetch image data
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.photoActivityIndicator.stopAnimating()
                        self.profilePhoto.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
