//
//  InvitesTableViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/30/22.
//

import UIKit
import SDWebImage

class InvitesTableViewController: UITableViewController {
    // MARK: - Properties
    var invitesWithNoChat: [SkiInvites] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        getSkiInvitesWithNoChat()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return invitesWithNoChat.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath) as? InviteTableViewCell else { return UITableViewCell() }
        
        cell.firstNameLabel.text = invitesWithNoChat[indexPath.row].inviterFirstName
        cell.skiDateLabel.text = DateFormatter().formatter.string(from: invitesWithNoChat[indexPath.row].inviteDate)
        let url = URL(string: invitesWithNoChat[indexPath.row].inviterPhotoURL)
        cell.profilePhoto.sd_setImage(with: url)
        cell.inviterUid = invitesWithNoChat[indexPath.row].inviterUid
        cell.delegate = self
        
        return cell
    }
    
    private func getSkiInvitesWithNoChat() {
        guard let user = UserController.shared.user else { return }
        user.skiInvites.forEach { skiInvite in
            if skiInvite.didStartConversation == false {
                self.invitesWithNoChat.append(skiInvite)
            }
        }
    }
} // End of class


extension InvitesTableViewController: InviteTableViewCellDelegate {
    func acceptInvite(uid: String) {
        print("In get ski invites protocol")
        // Save user invite and start conversation
        guard let user = UserController.shared.user else { return }
        
        user.skiInvites.forEach {
            if $0.inviterUid == uid {
                $0.didStartConversation = true
            }
        }
        
        UserController.shared.updateUser(user) { [weak self] success in
            if success {
                print("Did update user")
                DispatchQueue.main.async {
                    UserController.shared.user = user
                    self?.navigationController?.popViewController(animated: true)
                    self?.invitesWithNoChat = []
                    self?.getSkiInvitesWithNoChat()
                    self?.tableView.reloadData()
                    // Protocol to create a new Chat
                }
                return
            } else {
                print("Failed to update user")
                return
            }
        }
    }
}
