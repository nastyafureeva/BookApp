//
//  ViewController.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 03.04.2024.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    private lazy var contentView = LoginView()
    private let viewModel: LoginViewModel
    private var bindings = Set<AnyCancellable>()
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setUpTargets()
        setUpBindings()
    }

    private func setUpTargets() {
        contentView.signInButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        contentView.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
    }

    private func setUpBindings() {
        func bindViewToViewModel() {
            contentView.emailField.textPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.email, on: viewModel)
                .store(in: &bindings)

            contentView.passwordField.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.password, on: viewModel)
                .store(in: &bindings)
        }

        func bindViewModelToView() {
            viewModel.showAlertSubject
                .sink { [weak self] in
                    self?.showAlert()
                }
                .store(in: &bindings)
            print("VALID")
            
            
            viewModel.$validationError
                .sink { [weak self] error in
                    if let error = error {
                        self?.showAlert(error: error)
                    } else {
                        self?.navigateToList()
                    }
                }
                .store(in: &bindings)
        }


//            viewModel.validationResult
//                .sink { [weak self] completion in
//                    switch completion {
//                    case let .failure(error):
//                        print("HERE+ \(error)")
//                        self?.showAlert(error: error)
//                    case .finished:
//                        break
//                    }
//                } receiveValue: { [weak self] _ in
//                    self?.navigateToList()
//                }
//                .store(in: &bindings)
//        }
        bindViewToViewModel()
        bindViewModelToView()
    }

    @objc private func onClick() {
        viewModel.validateCredentials()
    }
    @objc private func didTapNewUser() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("DEBUG PRINT:", "didTapNewUser")
    }

    private func navigateToList() {
        let listViewController = HomeController()
        navigationController?.pushViewController(listViewController, animated: true)
    }
    func showAlert() {
        let alertController = UIAlertController(title: "Alert", message: "Привет, это alert из модели!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    func showAlert(error: Error) {
        DispatchQueue.main.async {
            let errorDescription = error.localizedDescription
            print(errorDescription)
            let alertController = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
