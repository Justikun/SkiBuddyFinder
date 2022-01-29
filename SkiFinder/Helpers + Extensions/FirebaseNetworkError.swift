//
//  NetworkError.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/14/22.
//

import Foundation

enum FirebaseNetworkError: LocalizedError {
    case document(Error)
    case noDocuments
    
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    case noSignedInUser
    
    var errorDescription: String? {
        switch self {
        case .document(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noDocuments:
            return "No documents"
        case .invalidURL:
            return "Bad URL: Unable to reach server"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noData:
            return "The server returned with no data"
        case .unableToDecode:
            return "There was an error trying to decode the data"
        case .noSignedInUser:
            return "There is no signed in user"
        }
    }
} // End of enum
