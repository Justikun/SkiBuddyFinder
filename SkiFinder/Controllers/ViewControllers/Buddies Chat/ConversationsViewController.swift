//
//  SkiBuddiesViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit

class ConversationsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var conversationTableView: UITableView!
    
    // MARK: - Properties
    private let chatCell = "chatCell"
    private var chats: [Chat] = []
    
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
        
        view.addSubview(noConversationsLabel)
        setupConversationTableView()
        
        fetchConversations()
        fetchChats()
    }

    // MARK: - Actions
    
    // MARK: - Methods
    
    private func fetchChats() {
        guard let user = UserController.shared.user else { return }
        DatabaseManager.shared.fetchAllChats(forUid: user.uid) { result in
            switch result {
            case .success(let chats):
                self.chats = chats
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
            }
        }
    }
    
    
    private func setupConversationTableView() {
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
    }

    
    private func fetchConversations() {
        conversationTableView.isHidden = false
    }
    
} // End of class

// Set up for conversation tableview
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: chatCell, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.chatImage.image = UIImage(named: "prism")
        cell.firstNameLabel.text = "Jonny"
        cell.messageLabel.text = "Well this is going to be a super long message because I have quite the story to tell you."
        cell.timeStampLabel.text = "2hrs"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unhighlights selected
        tableView.deselectRow(at: indexPath, animated: true)
        // Start conversation
        let targetUser = 0
        let vc = ChatViewController(with: <#T##User#>)
        vc.title = "Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
//
    }
} // End of class
