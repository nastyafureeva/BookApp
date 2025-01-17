//
//  Validator.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 24.04.2024.
//

import Foundation

class Validator {

    static func isValidEmail(for email: String) -> Bool {
        print("isValidemail \(email)")
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
                let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                return emailPred.evaluate(with: email)
    }

    static func isValidUsername(for username: String) -> Bool {

            let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        print("isValidUsername \(username)")
            let usernameRegEx = "\\w{3,24}"
            let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        print(usernamePred.evaluate(with: username))
            return usernamePred.evaluate(with: username)
        }

        static func isPasswordValid(for password: String) -> Bool {
            let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{3,32}$"
            let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
            return passwordPred.evaluate(with: password)
        }
}
