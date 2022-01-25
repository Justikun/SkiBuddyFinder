//
//  UserController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/9/22.
//

import UIKit
import Firebase
import FirebaseAuth

class UserController {
    // MARK: - Properties
    static let shared = UserController()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let auth = Auth.auth()
    var handler: AuthStateDidChangeListenerHandle?
    
    let userConstants = Constants.Firebase.User.self
    
    // Source of truth
    var user: User?
    
    func setCurrentUser() {
        // Get reference to the database
        let db = Firestore.firestore()
        
        // Read documents at a specific path
        db.collection("users")
    }
    
    // MARK: - CRUD
    // Create
    func signUpUser(withEmail email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                completion(.success(result))
                print("Authenticated")
            }
        }
    }
    
    func createUserInFirebase(user: User, completion: @escaping (Error?) -> Void ) {
        let db = Firestore.firestore()
        
        do {
            try _ = db.collection(Constants.Firebase.User.usersCollectionKey).addDocument(from: user)
            completion(nil)
        } catch let error {
            print("Error writing website to Firestore: \(error)")
            completion(error)
        }
    }
    
    // Fetch
    func fetchCurrentUser(completion: @escaping(Bool) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            self.db.collection(Constants.Firebase.User.usersCollectionKey).whereField(Constants.Firebase.User.uidKey, isEqualTo: currentUser.uid).getDocuments { snapshot, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                    completion(false)
                } else if let snapshot = snapshot {
                    let users: [User] = snapshot.documents.compactMap {
                        return try? $0.data(as: User.self)
                    }
                    self.user = users.first
                    completion(true)
                }
            }
        }
    }
    
    // SaveProfile Photo to storage
    func saveProfilePhoto(_ photo: UIImage, completion: @escaping(URL?) -> Void) {
        guard let uid = auth.currentUser?.uid else { return }
        
        let ref = self.storage.reference(withPath: uid)
        guard let imageData = photo.jpegData(compressionQuality: 0.01) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to push image to storage. Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                completion(nil)
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve downlaod URL. Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                    completion(nil)
                    return
                }
                
                guard let url = url else { return completion(nil)}
                self.user?.profilePhotoURL = url.absoluteString
                completion(url)
            }
        }
    }
    
    // Save Ski dates
    func saveSkiDates(_ skiDates: SkiDates, completion: @escaping (Bool) -> Void) {
        guard let user = user else { return }
        
        // Searching Firestore for a uid match of the user we want to update
        db.collection(Constants.Firebase.User.usersCollectionKey).whereField(Constants.Firebase.User.uidKey, isEqualTo: user.uid).getDocuments { snapshot, error in
            
            // Error handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                completion(false)
            } else {
                guard let snapshot = snapshot,
                   let documentID = snapshot.documents.first?.documentID else { return completion(false) }
                
                // Reference to the document (User) to update
                let ref = self.db.collection(Constants.Firebase.User.usersCollectionKey).document(documentID)
               
                do {
                    try ref.setData(from: user)
                    completion(true)
                } catch let error {
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                    completion(false)
                }
            }
        }
    }
    
    // Update
    func updateUser(_ user: User, completion: @escaping (Bool) -> Void) {
        
        // Searching Firestore for a uid match of the user we want to update
        db.collection(Constants.Firebase.User.usersCollectionKey).whereField(Constants.Firebase.User.uidKey, isEqualTo: user.uid).getDocuments { snapshot, error in
            
            // Error handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                completion(false)
            } else {
                guard let snapshot = snapshot,
                      let documentID = snapshot.documents.first?.documentID else { return }
                
                // Reference to the document (User) to update
                let ref = self.db.collection(Constants.Firebase.User.usersCollectionKey).document(documentID)
                do {
                    try ref.setData(from: user)
                    completion(true)
                } catch let error {
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                    completion(false)
                }
            }
        }
    }
    
        
    // Delete
}
