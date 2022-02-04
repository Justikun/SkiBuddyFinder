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
    @IBOutlet weak var notificationDot: UIView!
    
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        chatImage.setCircleShape()
        notificationDot.setCircleShape()
    }
    
    // MARK: - Methods

}
