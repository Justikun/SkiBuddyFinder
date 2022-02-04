//
//  ChatViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage

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
    public let otherUserUid: String
    private let conversationId: String?
    public var isNewConversation = false
    
    private var messages = [ChatMessage]()
    private var selfSender: Sender? {
        guard let user = UserController.shared.user,
              let userPhotoURL = user.profilePhotoURL else { return nil }
        return Sender(photoURL: userPhotoURL, senderId: user.uid, displayName: user.firstName)
    }
    

    init(with userUid: String, id: String?) {
        self.otherUserUid = userUid
        self.conversationId = id
        super.init(nibName: nil, bundle: nil)
        
        if let conversationId = conversationId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifcycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessages()
        markMessageRead()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesCollectionView.scrollToLastItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let user = UserController.shared.user else { return }
        user.chats.forEach { chat in
            if chat.conversationId == conversationId {
                chat.latestMessage?.isRead = true
            }
            
            UserController.shared.updateUser(user) { _ in }
        }
    }
    
    // MARK: - Methods
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id) { [weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else { return }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    self?.messageInputBar.inputTextView.becomeFirstResponder()
                }
            case .failure(let error):
                print("Failed to get messages: \(error)")
            }
        }
    }

    private func setupMessages() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    private func markMessageRead() {
        guard let user = UserController.shared.user else { return }
        
        user.chats.forEach { chat in
            if chat.conversationId == conversationId {
                chat.latestMessage?.isRead = true
            }
        }
        UserController.shared.updateUser(user) { _ in }
    }
    
} // End of class

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        // Check that message doesn't only have spaces
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId(),
              let conversationId = conversationId else { return }
        
        let message  = ChatMessage(sender: selfSender,
                                   messageId: messageId,
                                   sentDate: Date(),
                                   kind: .text(text))
        
        DatabaseManager.shared.sendMessage(to: conversationId, message: message, otherUserUid: otherUserUid) { success in
            if success {
                inputBar.inputTextView.text = ""
            } else {
                print("failed to send")
            }
        }
    }
    
    private func createMessageId() -> String? {
        // Components for uniqie message id: date, otherUserUid, senderUid
        guard let user = UserController.shared.user else { return nil }
        
        let dateString = DateFormatter().formatDateForId.string(from: Date())
        let newIdentifier = "\(otherUserUid)_\(user.uid)_\(dateString)"
        
        return newIdentifier
    }
    
} // End of extension

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil. User should be logged in")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
    }
} // End of extension
