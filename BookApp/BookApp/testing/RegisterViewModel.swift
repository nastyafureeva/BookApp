//
//  RegisterViewModel.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 20.05.2024.
//

import Foundation
final class RegisterViewModel {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""


    @Published var validationError: Error?


    func validateCredentials() {
        print("DEBUG PRINT:", "didTapSignUp")
        print("\(username)")

        if !Validator.isValidUsername(for: username){
            let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Некорректное имя"])
            print("inModelemail\(error)" )
            validationError = error
            return
        } else if !Validator.isValidEmail(for: email){
            let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка логина"])
            print("inModelemail\(error)" )
            validationError = error
            return
        } else if !Validator.isPasswordValid(for: password){
            let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка пароля"])
            print("inModelemail\(error)" )
            validationError = error
            return
        }
        let registerUserRequest = RegisterUserRequest(username: username,
                                                      email: email,
                                                      password: password )

        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }

            if let error = error {
                let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Неизвестная ошибка"])
                print("inModelemail\(error)" )
                validationError = error
            }

            if wasRegistered {
                validationError = nil
            } else {
                let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Неизвестная ошибка"])
                print("inModelemail\(error)" )
                validationError = error
            }
        }



    }
}
