//
//  AuthManager.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import Foundation
import FirebaseAuth

class AuthManager {
    /// Shared instance
    static let shared = AuthManager()
    
    let auth = Auth.auth()
    
    /// VerificationID
    private var verificationID: String?
    
} // End of class

// MARK: - Login/Signup with phone number
extension AuthManager {
    
    public func continueWith(phoneNumber: String, completion: @escaping (Bool) -> Void ) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                
            // Error Handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                return completion(false)
            }
            
            // Saves the verification ID and restore it when app loads.
            guard let verificationID = verificationID else {
                completion(false)
                return
            }
            
            self?.verificationID = verificationID
            completion(true)
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = verificationID else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
