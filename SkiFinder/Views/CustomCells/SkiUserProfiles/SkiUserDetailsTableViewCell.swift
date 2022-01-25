//
//  UserDetailsTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/18/22.
//

import UIKit
import SwiftUI

class SkiUserDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var proficiencyLabel: UILabel!
    @IBOutlet weak var passLocationLabel: UILabel!
    
    // MARK: - Properties
    var details: (firstName: String,
                  age: String,
                  location: String,
                  proficiency: String,
                  passLocation: String)? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let details = details else { return }

        nameLabel.text = details.firstName
        birthDateLabel.text = details.age
        locationLabel.text = details.location
        proficiencyLabel.text = details.proficiency
        passLocationLabel.text = details.passLocation
        
        
    }

}
