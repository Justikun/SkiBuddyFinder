//
//  SkiUserCalendarKeyTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/20/22.
//

import UIKit

class SkiUserSkiDatesKeyTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var willSkiColor: UIView!
    @IBOutlet weak var maybeSkiColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        willSkiColor.layer.cornerRadius = CGFloat(roundf(Float(self.willSkiColor.frame.size.height/2.0)))
        
        maybeSkiColor.layer.cornerRadius = CGFloat(roundf(Float(self.maybeSkiColor.frame.size.height/2.0)))
    }

}
