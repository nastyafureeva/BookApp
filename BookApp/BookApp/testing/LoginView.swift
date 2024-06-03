//
//  LoginView.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 13.05.2024.
//

import UIKit

class LoginView: UIView {
    // MARK: - UI Components
    private let headerView = AuthHeaderView(image: "logoImage", title: "Sign In", subTitle: "Sign in to your account")

     let emailField = CustomTextField(fieldType: .email )
     let passwordField = CustomTextField(fieldType: .password)

     let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
     let newUserButton = CustomButton(title: "New User? Create Account.", fontSize: .med)
    private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)

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
        addSubview(emailField)
        addSubview(passwordField)
        addSubview(signInButton)
        addSubview(newUserButton)
        addSubview(forgotPasswordButton)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo:leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 350),

            emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            passwordField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            newUserButton.heightAnchor.constraint(equalToConstant: 44),
            newUserButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            forgotPasswordButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        ])
    }
}

// MARK: - Selectors
//    @objc private func didTapSignIn() {
//        let loginRequest = LoginUserRequest(
//            email: self.emailField.text ?? "",
//            password: self.passwordField.text ?? "")
//
//        if !Validator.isValidEmail(for: loginRequest.email){
//            AlertManager.showInvalidEmailAlert(on: self)
//            return
//        }
//
//        if !Validator.isPasswordValid(for: loginRequest.password){
//            AlertManager.showInvalidPasswordAlert(on: self)
//            return
//        }
//
//        AuthService.shared.signIn(with: loginRequest) { [weak self] error in
//            guard let self = self else { return }
//            if let error = error {
//                AlertManager.showSignInErrorAlert(on: self, with: error)
//                return
//            }
//
//            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//                sceneDelegate.checkAuthentication()
//            }
//
//        }
//        print("DEBUG PRINT:", "didTapSignIn")
//    }
//
//    @objc private func didTapNewUser() {
//        let vc = RegisterController()
//        self.navigationController?.pushViewController(vc, animated: true)
//        print("DEBUG PRINT:", "didTapNewUser")
//    }
//
//    @objc private func didTapForgotPassword() {
//        let vc = ForgotPasswordController()
//        self.navigationController?.pushViewController(vc, animated: true)
//        print("DEBUG PRINT:", "didTapForgotPassword")
//    }
//}
//
