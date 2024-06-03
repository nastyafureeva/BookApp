//
//  RegisterUserRequest.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 24.04.2024.
//

import Foundation

struct RegisterUserRequest {
    let username: String
    let email: String
    let password: String

    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    var profilePicFileName: String {
        return "\(safeEmail)_profile_pic.png"
    }
}
