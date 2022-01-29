//
//  SkiBuddiesViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit

class BuddiesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var conversationTableView: UITableView!
    
    // MARK: - Properties
    
    private var buddies: [User] = []
    private var newSkiBuddiesView: UICollectionView?
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
        setupNewSkiBuddiesCollectionView()
        setupConversationTableView()
        
        fetchConversations()
        fetchBuddies()
        fetchChats()
    }

    // MARK: - Actions
    
    // MARK: - Methods
    private func fetchBuddies() {
        UserController.shared.fetchCurrentUser { success in
            if success {
                UserController.shared.getBuddies { result in
                    switch result {
                    case .success(let buddies):
                        DispatchQueue.main.async {
                            self.buddies = buddies
                            print("FETCH BUDDIES AND SET BUDDIES ARRAY")
                            self.newSkiBuddiesView?.reloadData()                            
                        }
                    case .failure(let error ):
                        print("Error in \(#function) : \(error.localizedDescription)\n---\n\(error)")
                    }
                }
            }
        }
    }
    
    private func fetchChats() {
        guard let user =  UserController.shared.user else { return }
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
    
    private func setupNewSkiBuddiesCollectionView() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        newSkiBuddiesView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        // Register NewBuddiesCollectionViewCell
        newSkiBuddiesView?.register(NewBuddyCollectionViewCell.self, forCellWithReuseIdentifier: NewBuddyCollectionViewCell.identifier)
        
        guard let newSkiBuddiesView = newSkiBuddiesView else { return }
        newSkiBuddiesView.showsHorizontalScrollIndicator = false
        newSkiBuddiesView.delegate = self
        newSkiBuddiesView.dataSource = self
        
        view.addSubview(newSkiBuddiesView)
    }

    
    private func fetchConversations() {
        conversationTableView.isHidden = false
    }
    
} // End of class


// Set up for conversation tableview
extension BuddiesViewController: UITableViewDelegate, UITableViewDataSource {
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
//        let targetUser = results[indexPath.row]
//        let vc = ChatViewController(with: id)
//        vc.title = "Jenny Smith"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}


// Set up for new buddies collection view
extension BuddiesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Sets the location of the entire collection view
        newSkiBuddiesView?.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 140).integral
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if buddies.count == 0 {
            // TODO: - Call a function to set a UILabel displaying no buddies
        }
        
        return buddies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBuddyCollectionViewCell.identifier, for: indexPath) as? NewBuddyCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(user: buddies[indexPath.row])
        return cell
    }
}

