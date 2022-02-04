//
//  DateExtension.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/12/22.
//

import Foundation

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
    
    func hoursAndMinutes() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "hh:mm a"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}
    
extension DateFormatter {
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    var formatDateForId: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }
}
