//
//  TextFieldExtension.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/24/22.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat = 12){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat = 12) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPillShape() {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.layer.masksToBounds = true
    }
    
}

extension UIButton {
    func setPillShape() {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.layer.masksToBounds = true
    }
    
    func setShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
}

extension UIViewController {
    //Show a basic alert
    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
      }
}
