//
//  SkiBuddiesViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit
import SDWebImage

class ConversationsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var conversationTableView: UITableView!
    
    // MARK: - Properties
    private let chatCell = "chatCell"
    private var chats: [Chat] = []
    private let inviteVCSegue = "toInvitesVC"
    
    private let loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        return indicator
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        InvitesTableViewController().delegate = self
        UserController.shared.updateNewUserPhotos()
        view.addSubview(noConversationsLabel)
        setupConversationTableView()
        fetchChats()
    }

    // MARK: - Actions
    
    // MARK: - Methods
    
    private func fetchChats() {
        guard let user = UserController.shared.user else { return print("failed refresh") }
        print("refresh Button pressed")
        DatabaseManager.shared.getAllChats(for: user.uid) { result in
            switch result {
            case .success(let chats):
                DispatchQueue.main.async {
                    if chats.count > 0 {
                        self.conversationTableView.isHidden = false
                    } else {
                        self.conversationTableView.isHidden = true
                    }
                    
                    self.chats = chats
                    self.conversationTableView.reloadData()
                    print("SUCCESS", "Chats:", chats.count)
                }
            case .failure(_):
                print("FAILURE")
            }
        }
    }
    
    
    private func setupConversationTableView() {
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == inviteVCSegue {
            guard let destination = segue.destination as? InvitesTableViewController else { return }
            destination.delegate = self
        }
    }
} // End of class

// Set up for conversation tableview
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: chatCell, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        let chat = chats[indexPath.row]
        
        // Setting profile image
        StorageManager.shared.getDownloadURL(for: chat.otherUserUid) { result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    cell.chatImage.sd_setImage(with: url)
                }
            case .failure(let error):
                print("Failed to download image", error.localizedDescription)
            }
        }
        
        // Setting timestamp label
        if let date = chat.latestMessage?.date {
            cell.timeStampLabel.text = date.hoursAndMinutes()
        } else {
            cell.timeStampLabel.text = ""
        }
        
        cell.firstNameLabel.text = chat.otherUserfirstName
        cell.messageLabel.text = chat.latestMessage?.message ?? ""
        
        // Setting notification dot        
        if let latestMessage = chat.latestMessage {
            if latestMessage.isRead {
                cell.notificationDot.isHidden = true
            } else {
                cell.notificationDot.isHidden = false
                cell.notificationDot.backgroundColor = UIColor(red: 243/255, green: 92/255, blue: 81/255, alpha: 1)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unhighlights selected
        tableView.deselectRow(at: indexPath, animated: true)
        // Start conversation
        let targetUser = chats[indexPath.row]
        let vc = ChatViewController(with: targetUser.otherUserUid, id: targetUser.conversationId)
        vc.title = targetUser.otherUserfirstName
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
//
    }
} // End of class

extension ConversationsViewController: InvitesTableViewControllerDelegate {
    func createNewConversation(with uid: String, name: String) {
        
        guard let conversationId = DatabaseManager.shared.createConversationId(otherUserUid: uid) else { return }
        let vc = ChatViewController(with: uid, id: conversationId)
        vc.title = name
        vc.isNewConversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
        DatabaseManager.shared.createNewConversation(with: uid, otherUserfirstName: name, conversationId: conversationId) { success in
            if success {
                print("successfully created conversations in conversation collection.")
            }
        }
    }
}
