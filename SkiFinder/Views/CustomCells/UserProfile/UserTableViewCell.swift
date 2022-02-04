//
//  UserTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/10/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var skillProficiencyLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var skiTypeLabel: UILabel!
    
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
            
        }
    }
    
    private let gradientLayer: CAGradientLayer = {
        // Fade gradient
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0).cgColor,
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
        ]
        
        layer.locations = [0.0, 0.6]
        return layer
    }()
    
//    private let fadeView2: UIView = {
//        // fadeViewContrainer
//        let view = UIView()
//        view.backgroundColor = .purple
//        return view
//    }()

    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        updateLookAndFeel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImage.layer.insertSublayer(gradientLayer, at: 1)
        gradientLayer.frame = CGRect(x: 0, y: self.frame.height - (self.frame.height / 2.5), width: self.frame.width, height: self.frame.height / 2.5)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let user = user else { return }
        
        nameAgeLabel.text = "\(user.firstName), \(user.birthDate.age)"
        bioLabel.text = user.bio
        skillProficiencyLabel.text = user.skiProficiency
        setSkiTypes(skiTypes: user.skiTypes)
        updateAndSetImage()
        
    }
    private func setSkiTypes(skiTypes: SkiTypes) {
        
        skiTypeLabel.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.black, radius: 5.0, opacity: 0.40)
        styleLabel.text = ""
        
        if skiTypes.snowboard == true && skiTypes.ski == true {
            skiTypeLabel.text = "⛷\n🏂"
            return
        }
        
        if skiTypes.ski == true {
            skiTypeLabel.text = "⛷"
            return
        }
        
        if skiTypes.snowboard == true {
            skiTypeLabel.text = "🏂"
            return
        }
        
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
    
} // End of class


// MARK: - Extensions
// Design
extension UserTableViewCell {
    func updateLookAndFeel() {
        skillProficiencyLabel.setPillShape1()
        skillProficiencyLabel.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.black, radius: 4.0, opacity: 0.40)
    }
}
