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
        db.collection(Constants.Firebase.User.usersCollectionKey).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(false)
            }
            
            if let snapshot = snapshot {
                var users = snapshot.documents.compactMap {
                    return try? $0.data(as: User.self)
                }
                
                // Removes own profile out of feed.
                users = self.filterSelfOut(of: users)
                
                // Remove any people you currently are in conversation with
                //TODO: - This function below doesn't work...
//                users = self.filterConversatingUsersOut(of: users)
                
                self.users = users
                return completion(true)
            }
        }
    }
    
    // Gets all users not currently in conversation with
    private func filterConversatingUsersOut(of users: [User]) -> [User] {
        guard let currentUser = UserController.shared.user else { return [] }
        
        let uidsInConversation: [String] = currentUser.chats.map { chat in
            return chat.otherUserUid
        }
        
        let filteredUsers = users.filter {
            uidsInConversation.contains($0.uid)
        }
        
        return filteredUsers
    }
    
    private func filterSelfOut(of users: [User]) -> [User] {
        guard let currentUser = AuthManager.shared.auth.currentUser else { return [] }
        
        let filteredUsers: [User] = users.filter { user in
            if user.uid != currentUser.uid {
                print(user.firstName)
                return true
            }
            return false
        }
        
        return filteredUsers
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
