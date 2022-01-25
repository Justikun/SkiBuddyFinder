//
//  AuthErrorCodeExtension.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/9/22.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again."
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 or more characters."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password."
        default:
            return "Unknown error occurred"
        }
    }
}
