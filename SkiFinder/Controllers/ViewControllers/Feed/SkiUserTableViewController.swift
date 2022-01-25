//
//  SkiUserTableViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/18/22.
//

import UIKit

class SkiUserTableViewController: UITableViewController {
    // MARK: - Properties
    var skiUser: User? {
        didSet {
            updateViews()
        }
    }
    
    let calendarCellController = SkiUserSkiDatesTableViewCell()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Methods
    func updateViews() {
        
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let skiUser = skiUser else { return UITableViewCell() }
        
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryBoard.cells.skiUserPhotoCell, for: indexPath) as? SkiUserPhotoTableViewCell else { return UITableViewCell() }

            cell.profilePhotoURL = skiUser.profilePhotoURL
            return cell
        } else if indexPath.row == 1 {
           
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryBoard.cells.skiUserDetailCell, for: indexPath) as? SkiUserDetailsTableViewCell else { return UITableViewCell() }
            
            let firstName = skiUser.firstName
            let age = "\(skiUser.birthDate.age)"
            let location = skiUser.currentLocation ?? ""
            let proficiency = skiUser.skiProficiency ?? ""
            let passLocation = skiUser.skiPassLocation ?? ""
            
                let details = (firstName: firstName,
                               age: age,
                               location: location,
                               proficiency: proficiency,
                               passLocation: passLocation)
                
                cell.details = details
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryBoard.cells.skiScheduleTitlteCell, for: indexPath) as? SkiScheduleHeaderTableViewCell else { return UITableViewCell() }
            
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryBoard.cells.skiUserCalendarCell, for: indexPath) as? SkiUserSkiDatesTableViewCell else { return UITableViewCell() }
            
            cell.user = self.skiUser
            cell.parentVC = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.StoryBoard.cells.skiUserCalendarKeyCell, for: indexPath) as? SkiUserSkiDatesTableViewCell else { return UITableViewCell() }
            
            return cell
        }
//        return UITableViewCell()
    }
}
