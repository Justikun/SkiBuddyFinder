//
//  ChatViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit
import MessageKit

struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    // MARK: - Properties
    public var otherUserId: String
    public var isNewConversation = false
    
    private var messages = [ChatMessage]()
    private var dummySender = Sender(photoURL: "", senderId: "1", displayName: "Wario")
    

    init(with id: String) {
        self.otherUserId = id
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifcycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessages()
        
        messages.append(ChatMessage(sender: dummySender, messageId: "1", sentDate: Date(), kind: .text("Hey Waluigi! I forgot the time we are going to Mario's to mess with him. Could you remind me the timw?")))
        messages.append(ChatMessage(sender: dummySender, messageId: "2", sentDate: Date(), kind: .text("time*")))
        view.backgroundColor = .purple
    }

    // MARK: - Methods
    private func setupMessages() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
} // End of class

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return dummySender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
