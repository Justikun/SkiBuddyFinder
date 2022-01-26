//
//  MobileInUse.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import Foundation
import FirebaseFirestoreSwift

class MobileInUse: Codable {
    var number: String
    
    init(number: String) {
        self.number = number
    }
}
