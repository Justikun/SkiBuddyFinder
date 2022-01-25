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
    
    var errorDescription: String? {
        switch self {
        case .document(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noDocuments:
            return "No documents"
        }
    }
} // End of enum
