//
//  UserCalendarViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/21/22.
//

import UIKit
import FSCalendar
import SwiftUI
import WebKit

class EditSkiDatesViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var willSkiButton: UIButton!
    @IBOutlet weak var maybeSkiButton: UIButton!
    

    // MARK: - Properties
    var skiDates: SkiDates? {
        didSet {
            setSkiDates()
        }
    }
    
    fileprivate let calendarCell = "calendarCell"
    fileprivate var willSkiActivated = true
    fileprivate var willSkiDateStrings = [String]()
    fileprivate var maybeSkiDateStrings = [String]()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: calendarCell)
        calendar.allowsMultipleSelection = true

        updateSelections()
        buttonStyles()
    }
    
    
    
    // MARK: - Actions
    @IBAction func willSkiPressed(_ sender: UIButton) {
        willSkiActivated = true
        buttonStyles()
    }
    @IBAction func maybeSkiPressed(_ sender: UIButton) {
        willSkiActivated = false
        buttonStyles()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveCalendarDates()
    }
    
    
    // MARK: - Methods
    func updateSelections() {
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
    
    func setSkiDates() {
        guard let skiDates = skiDates else { return }
        
        // Turning will dates into a String FSCalendar can read yyyy-MM-dd
        skiDates.willSkiDates.forEach { date in
            willSkiDateStrings.append(DateFormatter().formatter.string(from: date))
        }
        
        // Turning maybe ski dates into a String FSCalendar can read yyyy-MM-dd
        skiDates.maybeSkiDates.forEach { date in
            maybeSkiDateStrings.append(DateFormatter().formatter.string(from: date))
        }
    }
    
//    TODO: - Save calendar dates to firebase, and update source of truth
    func saveCalendarDates() {
        guard let skiDates = skiDates else { return }
        
        var willDates = [Date]()
        var maybeDates = [Date]()
        
        // Turns dateStrings into Dates
        willSkiDateStrings.forEach {
            if let date = DateFormatter().formatter.date(from: $0) {
                willDates.append(date)
            }
        }
        
        maybeSkiDateStrings.forEach {
            if let date = DateFormatter().formatter.date(from: $0) {
                maybeDates.append(date)
            }
        }
        
        // Saving as SkiDates object
        skiDates.willSkiDates = willDates
        skiDates.maybeSkiDates = maybeDates
        
        // Saving dates to firebase
        UserController.shared.saveSkiDates(skiDates) { success in
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Failed to save Ski Dates")
            }
        }
    }
    
} // End of class

// Calendar Setup
extension EditSkiDatesViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // Removes dates when deselected
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateStr = DateFormatter().formatter.string(from: date)
        
        willSkiDateStrings.removeAll { $0 == dateStr }
        maybeSkiDateStrings.removeAll { $0 == dateStr }

        updateSelections()
    }
    
    // Adds dates when selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateStr = DateFormatter().formatter.string(from: date)
        
        if willSkiActivated {
            willSkiDateStrings.append(dateStr)
        } else {
            maybeSkiDateStrings.append(dateStr)
        }
    
        updateSelections()
        calendar.reloadData()
        calendar.currentPage = date
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

// Button Styles
extension EditSkiDatesViewController {
    
    func buttonStyles() {
        willSkiButton.titleLabel?.text = "Will Ski"
        maybeSkiButton.titleLabel?.text = "Open to Ski"
        
        willSkiButton.layer.masksToBounds = true
        willSkiButton.layer.cornerRadius = CGFloat(Float(self.willSkiButton.frame.size.height/2.0))
        
        maybeSkiButton.layer.masksToBounds = true
        maybeSkiButton.layer.cornerRadius = CGFloat(Float(self.willSkiButton.frame.size.height/2.0))
        
        if willSkiActivated {
            // Will Ski Button - ACTIVE
            willSkiButton.setTitleColor(.white, for: .normal)
            willSkiButton.backgroundColor = UIColor(red: 108/255, green: 182/255, blue: 246/255, alpha:1)
            willSkiButton.layer.borderWidth = 1
            willSkiButton.layer.borderColor = CGColor(red: 65/255, green: 147/255, blue: 218/255, alpha:1)
            
            // Maybe Ski Button - PASSIVE
            maybeSkiButton.titleLabel?.textColor = UIColor(red: 237/255, green: 161/255, blue: 86/255, alpha: 0.2)
            maybeSkiButton.layer.borderWidth = 0
            maybeSkiButton.backgroundColor = UIColor(red: 237/255, green: 161/255, blue: 86/255, alpha: 0.2)
        
        } else {
            // Will Ski Button - PASSIVE
            willSkiButton.titleLabel?.textColor = UIColor(red: 52/255, green: 148/255, blue: 202/255, alpha: 0.5)
            willSkiButton.layer.borderWidth = 0
            willSkiButton.backgroundColor = UIColor(red: 52/255, green: 148/255, blue: 202/255, alpha: 0.2)
            
            // Maybe Ski Button - ACTIVE
            maybeSkiButton.setTitleColor(.white, for: .normal)
            maybeSkiButton.backgroundColor = UIColor(red: 237/255, green: 161/255, blue: 86/255, alpha:1)
            maybeSkiButton.layer.borderWidth = 1
            maybeSkiButton.layer.borderColor = CGColor(red: 180/255, green: 114/255, blue: 50/255, alpha:1)
        }
    }
} // End of extension
