//
//  AllUsersController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/17/22.
//

import UIKit
import Firebase

class AllUsersController {
    // MARK: - Properties
    
    // Singleton
    static let shared = AllUsersController()
    
    // Firebase
    let db = Firestore.firestore()
    
    //Source of Truth
    var users: [User] = []
    
    // MARK: - Methods
    
    func getUsers(completion: @escaping(Bool) -> Void) {
        db.collection(Constants.Firebase.User.usersCollectionKey).getDocuments { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(false)
            }
            
//            TODO: - Filter out the current user ( This way you don't see yourself)
            if let snapshot = snapshot {
                let users = snapshot.documents.compactMap {
                    return try? $0.data(as: User.self)
                }
                
                self.users = users
                return completion(true)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    func getUIImage(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Create URL
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                // Fetch Image Data
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    return completion(image)
                }
            }
        }
    }
}
