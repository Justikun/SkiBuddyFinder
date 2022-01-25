//
//  SkiUserCalendarTableViewCell.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/19/22.
//

import FSCalendar
import UIKit

class SkiUserSkiDatesTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet var calendar: FSCalendar!
    
    // MARK: - Properties
    fileprivate let calendarCell = "skiUserDatesCell"

    var willSkiDateStrings = [String]()
    var maybeSkiDateStrings = [String]()
    
    var user: User? {
        didSet {
            setSkiDates()
            updateSkiDates()
        }
    }
    
    var parentVC: UITableViewController?

    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: calendarCell)
        calendar.allowsMultipleSelection = true
    }
    
    // MARK: - Methods
    func setSkiDates() {
        guard let user = user else { return }
        
        user.skiDates.willSkiDates.forEach { date in
            let dateStr = DateFormatter().formatter.string(from: date)
            self.willSkiDateStrings.append(dateStr)
        }
        
        user.skiDates.maybeSkiDates.forEach { date in
            let dateStr = DateFormatter().formatter.string(from: date)
            self.maybeSkiDateStrings.append(dateStr)
        }
    }
    
    func presentSkiInvitationAlert() {
        guard let user = user,
              let parentVC = parentVC else { return }
        
        let okAction = UIAlertAction(title: "Send", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let requestAlert = UIAlertController(title: "Send Ski Request?", message: "If \(user.firstName) accepts your ski request, a chat will be opened", preferredStyle: .alert)
        
        requestAlert.addAction(okAction)
        requestAlert.addAction(cancelAction)

        parentVC.present(requestAlert, animated: true, completion: nil)
    }
}

extension SkiUserSkiDatesTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // Imports user's ski dates to display on the calendar
    func updateSkiDates() {
        willSkiDateStrings.forEach { dateStr in
            calendar.select(DateFormatter().formatter.date(from: dateStr))
        }
        
        maybeSkiDateStrings.forEach { dateStr in
            calendar.select(DateFormatter().formatter.date(from: dateStr))
        }
        
        print("\n\n")
        print("-----will------")
        print(willSkiDateStrings)
        print("-----maybe------")
        print(maybeSkiDateStrings)
    }
    
    // Present UIAlert when selecting 'active' date
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateStr = DateFormatter().formatter.string(from: date)
        
        if willSkiDateStrings.contains(dateStr) {
            presentSkiInvitationAlert()
        }

        if maybeSkiDateStrings.contains(dateStr) {
            presentSkiInvitationAlert()
        }
        
        calendar.select(date)
    }

    // Selection colors for willSkiDates and maybeSkiDates
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let strDate = DateFormatter().formatter.string(from: date)
        
        if self.willSkiDateStrings.contains(strDate) {
            return UIColor(red: 108/255, green: 182/255, blue: 246/255, alpha: 1)
        }
        
        if self.maybeSkiDateStrings.contains(strDate) {
            return UIColor(red: 237/255, green: 161/255, blue: 86/255, alpha: 1)
        }
        
        return nil
    }
} // End of extension
