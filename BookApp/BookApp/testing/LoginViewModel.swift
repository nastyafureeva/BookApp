//
//  LoginViewModel.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 13.05.2024.
//

import Foundation
import Combine

final class LoginViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var validationError: Error?


    let validationResult = PassthroughSubject<Void, Error>()
    let showAlertSubject = PassthroughSubject<Void, Never>()

    func showAlert() {
        showAlertSubject.send()    }


    //    private let credentialsValidator: CredentialsValidatorProtocol
    //
    //    init(credentialsValidator: CredentialsValidatorProtocol = CredentialsValidator()) {
    //        self.credentialsValidator = credentialsValidator
    //    }
    func validateCredentials() {
        if !Validator.isValidEmail(for: email) {
            let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка логина"])
            print("inModelemail\(error)" )
            validationError = error  }
        else if !Validator.isPasswordValid(for: password) {
                let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка пароля"])
            validationError = error
            } else {
                validationError = nil
            }
        }

        //    func validateCredentials() {
        //        credentialsValidator.validateCredentials( email: email, password: password) { [weak self] result in
        //            switch result {
        //            case .success:
        //                self?.validationResult.send(())
        //            case let .failure(error):
        //                print("SEND \(error)")
        //                self?.validationResult.send(completion: .failure(error))
        //
        //            }
        //        }
        //    }
    }

    // MARK: - CredentialsValidatorProtocol

    //enum ValidationResult {
    //    case success
    //    case failure
    //}
    //
    //
    //protocol CredentialsValidatorProtocol {
    //    func validateCredentials(
    //        email: String,
    //        password: String,
    //        completion: @escaping (Result<(), Error>) -> Void)
    //}
    //
    //final class CredentialsValidator: CredentialsValidatorProtocol {
    //    func validateCredentials(
    //        email: String,
    //        password: String,
    //        completion: @escaping (Result<Void, Error>) -> Void) {
    //            let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1_000))
    //            DispatchQueue.main.asyncAfter(deadline: time) {
    //                if !Validator.isValidEmail(for: email) {
    //                    let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка логина"])
    //                    print("inModelemail\(error)" )
    //                    completion(.failure(error))
    //                } else if !Validator.isPasswordValid(for: password) {
    //                    let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка пароля"])
    //                    completion(.failure(error))
    //                } else {
    //                    completion(.success(<#()#>))
    //                }
    //
    //            }
    //        }
    //}
    //
    //enum ValidationResult {
    //    case success
    //    case failure
    //}
    //
    //protocol CredentialsValidatorProtocol {
    //    func validateCredentials(
    //        email: String,
    //        password: String,
    //        completion: @escaping (Result<Void, Error>) -> Void)
    //}
    //
    //final class CredentialsValidator: CredentialsValidatorProtocol {
    //    func validateCredentials(
    //        viewmodel: LoginViewModel,
    //        email: String,
    //        password: String,
    //        completion: @escaping (Result<Void, Error>) -> Void) {
    //            let time: DispatchTime = .now() + .milliseconds(Int.random(in: 200 ... 1_000))
    //            DispatchQueue.main.asyncAfter(deadline: time) {
    //                if !Validator.isValidEmail(for: email) {
    //                    let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка логина"])
    //                    validationError = error
    //                    completion(.failure(error))
    //                } else if !Validator.isPasswordValid(for: password) {
    //                    let error = NSError(domain: "com.example", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка пароля"])
    //                    completion(.failure(error))
    //                } else {
    //                    completion(.success(()))
    //                }
    //            }
    //        }
    //}
