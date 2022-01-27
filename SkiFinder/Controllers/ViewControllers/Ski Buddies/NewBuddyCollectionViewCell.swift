//
//  NewBuddyCollectionViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit

class NewBuddyCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewBuddyCollectionViewCell"
    
    // Anonymous closure - Set up for the profile pic
    private let profilePic: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 80/2.0
        imageView.backgroundColor = .gray
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.center = CGPoint(x: 160, y: 285)
        name.textAlignment = .center
        name.font = name.font.withSize(13)
        return name
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        contentView.addSubview(profilePic)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePic.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        nameLabel.frame = CGRect(x: 0, y: 90, width: 80, height: 22)
    }
    
    public func configure(with name: String) {
        profilePic.image = UIImage(named: name)
        nameLabel.text = "Madi"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePic.image = nil
        nameLabel.text = ""
    }
}
