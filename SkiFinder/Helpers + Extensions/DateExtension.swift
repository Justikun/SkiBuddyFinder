//
//  DateExtension.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/12/22.
//

import Foundation

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}
    
extension DateFormatter {
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
