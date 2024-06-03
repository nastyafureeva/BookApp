//
//  RegisterView.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 20.05.2024.
//

//
//  RegisterViewController.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 23.04.2024.
//

import UIKit

class RegisterView: UIView {
    // MARK: - UI Components
    let headerView = AuthHeaderView(image: "logoRegister", title: "Sign Up", subTitle: "Create your account")

    let usernameField = CustomTextField(fieldType: .username)
    let emailField = CustomTextField(fieldType: .email)
    let passwordField = CustomTextField(fieldType: .password)

    let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    let signInButton = CustomButton(title: "Already have account? Sign in", fontSize: .med)

    let termsTextView: UITextView = {
        let tv = UITextView()
        tv.text = "By creating an account, you agree our Terms & Condition you acknowledge"
        tv.backgroundColor = .clear
        tv.textColor = .label
        tv.isSelectable = true
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()

    // MARK: - LifeCycle
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .systemBackground

        addSubview(headerView)
        addSubview(usernameField)
        addSubview(emailField)
        addSubview(signUpButton)
        addSubview(passwordField)
        addSubview(termsTextView)
        addSubview(signInButton)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 222),

            usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 55),
            usernameField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
            emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            passwordField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
            termsTextView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            termsTextView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 11),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            signInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        ])
    }

    // MARK: - Selectors

}
