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
    private let db = Firestore.firestore()
    
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
} // End of class

// MARK: - Sending messages

extension DatabaseManager {
    
    /// Creates a new conversation with target users uid
    public func createNewConversation(with otherUid: String, otherUserfirstName: String, conversationId: String, completion: @escaping(Bool) -> Void) {
        guard let user = UserController.shared.user else { return completion(false) }
        let conversationsRef = db.collection("conversations")
        let usersRef = db.collection("users")
        
        // Adding chat id into user
        user.chats.append(Chat(conversationId: conversationId, otherUserfirstName: otherUserfirstName, otherUserUid: otherUid, latestMessage: nil))
        
    
        // Adding conversation in conversation collection
        let newConversation = Conversation(conversationId: conversationId, messages: [])
        
        // Update recipient chat entry
        usersRef.document(otherUid).getDocument { document, error in
            guard let document = document else {
                print("Error fetching documents: \(error!)")
                return completion(false)
            }
            
            do {
                guard let otherUser = try document.data(as: User.self) else { return completion(false) }
                let chat = Chat(conversationId: conversationId, otherUserfirstName: user.firstName, otherUserUid: user.uid, latestMessage: nil)
                
                otherUser.chats.append(chat)
                UserController.shared.updateUser(otherUser) { success in
                    guard success else {
                        print("Failed to update other user conversation")
                        return completion(false)
                    }
                }
                
            } catch let error {
                print("Error decoding: \(error.localizedDescription)")
                return completion(false)
            }
        }
        
        // Update current user chat entry
        do {
            try conversationsRef.document(conversationId).setData(from: newConversation)
            try usersRef.document(user.uid).setData(from: user)
            return completion(true)
        } catch let error{
            print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
            return completion(false)
        }
    }
    
    public func createConversationId(otherUserUid: String) -> String? {
        // Components for uniqie message id: date, otherUserUid, senderUid
        guard let user = UserController.shared.user else { return nil }
        
        let dateString = DateFormatter().formatDateForId.string(from: Date())
        let newIdentifier = "conversation_\(otherUserUid)_\(user.uid)_\(dateString)"
        
        return newIdentifier
    }
    
    /// Fetches and returns all conversations for target user uid
    public func getAllChats(for uid: String, completion: @escaping(Result<[Chat], Error>) -> Void) {
        let usersRef = db.collection(Constants.Firebase.User.usersCollectionKey)

        usersRef.document(uid).addSnapshotListener { document, error in
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(.failure(error!))
                return
            }
            
            do {
                let user = try document.data(as: User.self)
                guard let chats = user?.chats else {
                    print("No chats")
                    completion(.success([]))
                    return
                }
                return completion(.success(chats))
            } catch let error {
                print("Failed to decode data")
                return completion(.failure(error))
            }
            
        }
    }
    
    /// Fetches all messages for target conversation id
    public func getAllMessagesForConversation(with id: String, completion: @escaping(Result<[ChatMessage], Error>) -> Void) {
        let conversationsRef = db.collection("conversations")
        conversationsRef.document(id).addSnapshotListener { document, error in
            guard let document = document else {
                print("Error fetching document: \(error!)")
                completion(.failure(error!))
                return
            }
            
            do {
                let conversation = try document.data(as: Conversation.self)
                guard let conversationMessages = conversation?.messages else {
                    completion(.success([]))
                    return
                }
                
                let messages: [ChatMessage] = conversationMessages.compactMap { message in
                    
                    let sender = Sender(photoURL: "",
                                        senderId: message.senderUid,
                                        displayName: message.senderFirstName)
                    
                    return ChatMessage(sender: sender,
                                messageId: message.messageId,
                                sentDate: message.date,
                                kind: .text(message.content))
                }
                
                return completion(.success(messages))
            } catch let error {
                print("Failed to decode data")
                return completion(.failure(error))
            }
        }
    }
    
//    var messageId: String
//    var senderUid: String
//    var otherUserFirstName: String
//    var content: String
//    var date: Date
//    var isRead: Bool
    
//    struct ChatMessage: MessageType {
//        var sender: SenderType
//        var messageId: String
//        var sentDate: Date
//        var kind: MessageKind
//    }
//
//    struct Sender: SenderType {
//        var photoURL: String
//        var senderId: String
//        var displayName: String
//    }
    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, message: ChatMessage, completion: @escaping(Bool) -> Void) {
        
        
        var content = ""
        
        switch message.kind {
        case .text(let messageText) :
            content = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let conversationRef = db.collection("conversations").document(conversation)
        
        conversationRef.updateData(["messages" : FieldValue.arrayUnion([[
            "message_id" : message.messageId,
            "sender_uid" : message.sender.senderId,
            "sender_first_name" : message.sender.displayName,
            "is_read" : false,
            "content" : content,
            "type" : "text",
            "sent_date" : message.sentDate
        ]])])
    }
} // End of extension
