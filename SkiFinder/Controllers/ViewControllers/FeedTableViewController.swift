//
//  FeedTableViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/9/22.
//

import UIKit
import Firebase 

class FeedTableViewController: UITableViewController {
    // MARK: - Properties
    var handler: AuthStateDidChangeListenerHandle?
    
    // MARK: - Outlets

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AllUsersController.shared.getUsers { success in
            if success {
                self.updateViews()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handler = Auth.auth().addStateDidChangeListener({ auth, user in
            if user != nil {
                print("Currently In")
                self.getCurrentUser()
            }
        })
    }
    // MARK: - Actions
    @IBAction func signOutButtonPressed(_ sender: Any) {
        signOut()
    }
        
    // MARK: - Methods
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Signed out")
        } catch {
            print("Unable to sign out")
        }
    }
    
    func getCurrentUser() {
        if let user = Auth.auth().currentUser {
            print("Email: \(user.email!)")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AllUsersController.shared.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        cell.user = AllUsersController.shared.users[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == Constants.StoryBoard.segues.toSkiUserProfile {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? SkiUserTableViewController else { return }
            
            let skiUser = AllUsersController.shared.users[indexPath.row]
            destination.skiUser = skiUser
        }
    }
} // End of class

