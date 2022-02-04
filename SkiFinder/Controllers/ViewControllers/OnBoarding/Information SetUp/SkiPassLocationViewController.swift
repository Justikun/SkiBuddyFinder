//
//  SkiPassLocationViewController.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/25/22.
//

import UIKit

class SkiPassLocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var skiPassTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    var user: User?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        skiPassTextField.becomeFirstResponder()
        setUpStyles()
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let user = user,
              let skiPassLocation = skiPassTextField.text else { return }
        
        user.skiPassLocation = skiPassLocation
        performSegue(withIdentifier: "toSkiProficiencyVC", sender: user)
    }
    
    
    // MARK: - Methods
    private func setUpStyles() {
        skiPassTextField.setPillShape()
        skiPassTextField.setLeftPaddingPoints()
        continueButton.setPillShape()
        continueButton.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 3.0, opacity: 0.20)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSkiProficiencyVC" {
            guard let destination = segue.destination as? SkiProficiencyViewController,
                  let user = sender as? User else { return }
            
            destination.user = user
        }
    }
}
