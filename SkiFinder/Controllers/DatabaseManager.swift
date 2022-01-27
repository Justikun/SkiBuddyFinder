//
//  DatabaseManager.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import Foundation
import FirebaseFirestore

struct Strings {
    static let mobileNumbers = "mobile_numbers"
}

class DatabaseManager {
    /// Shared instance
    static let shared = DatabaseManager()
    
    /// Database
    private var db = Firestore.firestore()
    
    
    /// Checks if phone number is in use
    func checkMobile(number: String, completion: @escaping (Bool) -> Void) {
        db.collection(Strings.mobileNumbers).whereField("number", isEqualTo: number).getDocuments { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(false)
            } else if let snapshot = snapshot {
                do {
                    let number = try snapshot.documents.first?.data(as: MobileInUse.self)
                    if let _ = number {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch  {
                    // Mobile number is not in use
                    return completion(false)
                }
            }
        }
    }
    
    /// Adds phone number active phone numbers in firebase
    func addNumberToMobileNumbers(mobile: MobileInUse, completion: @escaping(Bool) -> Void) {
        do {
            try _ = db.collection(Strings.mobileNumbers).addDocument(from: mobile)
            completion(true)
        } catch let error {
            print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
            completion(false)
        }
    }
}
