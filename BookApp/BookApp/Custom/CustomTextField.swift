//
//  CustomTextField.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 07.04.2024.
//

import UIKit
import Combine

class CustomTextField: UITextField {

    enum CustomTextFieldType {
        case username
        case email
        case password
    }

    private let authFieldType: CustomTextFieldType

    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)

        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10

        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none

        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))

        switch fieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress

        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CustomTextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: CustomTextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? CustomTextField } // receiving notifications with objects which are instances of UITextFields
            .compactMap(\.text) // extracting text and removing optional values (even though the text cannot be nil)
            .eraseToAnyPublisher()
    }
}
