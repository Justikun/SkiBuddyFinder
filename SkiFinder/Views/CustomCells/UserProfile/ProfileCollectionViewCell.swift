//
//  ProfileCollectionViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/11/22.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        photoImageView.image = photoImage
    }
}
