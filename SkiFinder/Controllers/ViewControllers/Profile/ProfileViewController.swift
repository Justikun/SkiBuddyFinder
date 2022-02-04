//
//  ProfileViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/12/22.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameAndAgeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties

    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    // MARK: - Actions
    @IBAction func addPhotoPressed(_ sender: UIButton) {
        UserController.shared.fetchCurrentUser { didFetch in
            if didFetch {
                print("fetched form photoPressed")
                self.updateViews()
            }
        }
    }
    
    // MARK: - Methods
    @objc func updateViews() {
        DispatchQueue.main.async {
            if self.profilePicture.image == nil {
                self.photoActivityIndicator.startAnimating()
            }
            self.profilePicture.setPillShape3()
            guard let user = UserController.shared.user else { return }
            self.nameAndAgeLabel.text = "\(user.firstName), \(user.birthDate.age)"
            self.getImage()
        }
    }
    
    func getImage() {
        // Create URL
        guard let urlString = UserController.shared.user?.profilePhotoURL else { return }
        if let url = URL(string:  urlString) {
            DispatchQueue.global().async {
                // Fetch image data)
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.photoActivityIndicator.stopAnimating()
                        self.profilePicture.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryBoard.segues.toEditProfileVC {
            guard let destination = segue.destination as? EditProfileTableViewController,
                  let profileUIImage = profilePicture.image else { return }
                    
            destination.profileUIImage = profileUIImage
        } else if segue.identifier == Constants.StoryBoard.segues.toEditSkiDatesVC {
            guard let destination = segue.destination as? EditSkiDatesViewController,
                  let skiDates = UserController.shared.user?.skiDates else { return }
            
            destination.skiDates = skiDates
        }
    }
    
} // End of class


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let photoNames = ["1", "2", "3", "4", "5", "6","7", "8", "9", "10", "11", "12"]
        return photoNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionVIewCell", for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        
        let photoNames = ["1", "2", "3", "4", "5", "6","7", "8", "9", "10", "11", "12"]
        let photo = UIImage(named: photoNames[indexPath.row])
        cell.photoImage = photo
    
        return cell
    }
} // End of extension

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
} // End of extension
