//
//  SkiBuddiesViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/26/22.
//

import UIKit

class Buddies: UIViewController {
    // MARK: - Properties
    private var newSkiBuddiesView: UICollectionView?
    private let dummyImages = ["prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine", "prism", "pine"]
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
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


} // End of class

extension Buddies: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Sets the location of the entire collection view
        newSkiBuddiesView?.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 140).integral
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBuddyCollectionViewCell.identifier, for: indexPath) as? NewBuddyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: dummyImages[indexPath.row])
        
        return cell
    }
}

