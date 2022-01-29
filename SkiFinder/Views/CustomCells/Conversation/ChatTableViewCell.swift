//
//  ChatTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/28/22.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        chatImage.setCircleShape()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods

}
