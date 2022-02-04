//
//  UserController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/9/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

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
    
    /// Sign up a user
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
    
    /// Creates a user in Firestore from type User
    func createUserInFirebase(user: User, completion: @escaping (Error?) -> Void ) {
        let db = Firestore.firestore()
        
        do {
            try db.collection(Constants.Firebase.User.usersCollectionKey).document(user.uid).setData(from: user)
            completion(nil)
        } catch let error {
            print("Error writing website to Firestore: \(error)")
            completion(error)
        }
    }
    
    /// Fetch user by uid
    func fetchUser(by uid: String, completion: @escaping(User?) -> Void) {
        let userRef = db.collection(Constants.Firebase.User.usersCollectionKey)
        
        userRef.whereField(Constants.Firebase.User.uidKey, isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(nil)
            } else if let snapshot = snapshot {
                let user = try? snapshot.documents.first?.data(as: User.self)
                return completion(user)
            }
        }
    }
    
    /// Fetch currently signed in user
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
    
    /// SaveProfile Photo to storage
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
    
    /// Saves Ski dates for the current user on firestore
    func saveSkiDates(_ skiDates: SkiDates, completion: @escaping (Bool) -> Void) {
        guard let user = user else { return completion(false) }
        
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
    
    /// Updates user information on Firestore
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
    
        
    /// Returns an array of the current user's invites
    func getSkiInviters(completion: @escaping (Result<[User], FirebaseNetworkError>) -> Void) {
        guard let user = user else { return completion(.failure(.noSignedInUser))}
        
        // Gets all the uids for each buddy the current user hasn't started a converation with
        let buddyUids: [String] = user.skiInvites.compactMap { skiInvite in
            if !skiInvite.didStartConversation {
                return skiInvite.inviterUid
            }
            return nil
        }
        
        
        let usersRef = db.collection("users")
        // TODO: - This 'in' operation will only grab 10 elements. Paginate the data to get the other elements
        usersRef.whereField("uid", in: buddyUids).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            } else if let snapshot = snapshot {
                do {
                    let users: [User] = try snapshot.documents.compactMap({
                        try $0.data(as: User.self)
                    })
                    
                    return completion(.success(users))
                } catch {
                    return completion(.failure(.unableToDecode))
                }
            }
        }
    }
    
    func addSkiInivite(inviterUid: String, inviteeUid: String, date: Date) {

    }
    
    /// Fetches new images other users set for their profile pic
    func updateNewUserPhotos() {
        guard let user = user else { return }
        
        for i in user.skiInvites {
            let ref = storage.reference(withPath: i.inviterUid)
            // Retreieves url from firebase storage
            ref.downloadURL { url, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                } else if let url = url {
                    i.inviterPhotoURL = url.absoluteString
                }
            }
        }
    }
    /// Deletes a user on firestore
}
