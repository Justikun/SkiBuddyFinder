//
//  OneTimeAuthTextField.swift
//  SkiFinder
//
//  Created by Justin Lowry on 1/24/22.
//

import UIKit

class OneTimeCodeTextField: UITextField {
    
    // MARK: - Properties
    /// Checks if the the one time code has been configured.
    private var isConfigured = false
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        
        return recognizer
    }()
    
    // Closure to check if last digit in the code was typed
    var didEnterLastDigit: ((String) -> Void)?
    
    var defaultCharacterValue = "·"
    
    // MARK: - Methods
    /// Setting up how many characters the code is going to be (Firebase is 6)
    func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        // Allows the text field to recognize taps
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
    
    /// Configures text field so it's not seen by the user
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        // This gets called everytime the user taps a key
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    /// Creates stack view so each individual number in the code has a place to be displayed
    private func createLabelsStackView(with count: Int) -> UIStackView {
        
        // Creates Stack view
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        // Creates labels in the stack view
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.isUserInteractionEnabled = true
            label.text = defaultCharacterValue
            
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
    
        return stackView
    }
    
    // Changes the text based on the user input
    @objc private func textDidChange() {
        guard let text = self.text,
              text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = defaultCharacterValue
            }
            
        }
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
    }

} // End of class

extension OneTimeCodeTextField: UITextFieldDelegate {
    // Make sure only the count of digits are equal or less than.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
