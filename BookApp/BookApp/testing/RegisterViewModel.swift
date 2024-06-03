//
//  RegisterViewModel.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 20.05.2024.
//

import Foundation
import UIKit
final class RegisterViewModel {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var image: UIImage?

    @Published var validationError: Error?


    func validateCredentials() {
        print("DEBUG PRINT:", "didTapSignUp")
        print("\(username)")

        if !Validator.isValidUsername(for: username){
            let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Некорректное имя"])
            print("inModelVALIDUsername\(error)" )
            validationError = error
            return
        } else if !Validator.isValidEmail(for: email){
            let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка логина"])
            print("inModelVALIDEmail\(error)" )
            validationError = error
            return
        } else if !Validator.isPasswordValid(for: password){
            let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка пароля"])
            print("inModelVALIDPassword\(error)" )
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
                print("REGISTER\(error)" )
                validationError = error
            }

            if wasRegistered {
                print("WAS REGISTERED")
                validationError = nil
                guard let pic = image,
                      let data = pic.pngData() else{
                    return
                }
                let fileName = registerUserRequest.profilePicFileName
                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                    switch result {
                    case .success(let downloadURL):
                        UserDefaults.standard.set(downloadURL, forKey: "profile_pic_URL")
                        print(downloadURL)
                    case .failure(let error):
                        print("Storage error: \(error)")
                    }
                })
            } else {
                let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Неизвестная ошибка"])
                print("Was reg, but \(error)" )
                validationError = error
            }
        }



    }
}
