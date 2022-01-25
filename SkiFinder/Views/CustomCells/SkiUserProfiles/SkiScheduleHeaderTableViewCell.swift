//
//  SkiScheduleTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/18/22.
//

import UIKit

class SkiScheduleHeaderTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titlelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    // MARK: - Methods
    func updateViews() {
        titlelabel.text = "Ski Schedule"
    }
}
