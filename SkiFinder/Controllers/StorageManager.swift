//
//  StorageManager.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/28/22.
//

import Foundation
import FirebaseStorage

class StorageManager {
    /// Shared instance
    static let shared = StorageManager()
    
    private let storage = Storage.storage()
    
    
    // MARK: - Methods
    
    /// Get the download URL by storage path
    func getDownloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let uid = auth.currentUser?.uid else { return }
        
        let ref = storage.reference(withPath: path)
        
        // Retreieves url from firebase storage
        ref.downloadURL { url, error in
            if let error = error {
                return completion(.failure(error))
            } else if let url = url {
                return completion(.success(url))
            }
        }
    }
}
