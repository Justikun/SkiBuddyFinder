//
//  InviteTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/31/22.
//

import UIKit

protocol InviteTableViewCellDelegate {
    func acceptInvite(uid: String)
}

class InviteTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var skiDateLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK: - Properties
    var inviterUid: String?
    var delegate: InviteTableViewCellDelegate?
     
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePhoto.setCircleShape()
        
    }

    // MARK: - Actions
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        guard let inviterUid = inviterUid else { return }

        print("Pressed Accept Button")
        delegate?.acceptInvite(uid: inviterUid)
    }
    
    // MARK: - Methods
    
}
