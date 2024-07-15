//
//  ViewController.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 03.04.2024.
//

import UIKit
import Combine
import SwiftUI

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
            print("VALID")


            viewModel.$validationError
                .sink { [weak self] error in
                    if let error = error {
                        self?.showAlert(error: error)
                    }
                }
                .store(in: &bindings)

            viewModel.$isSuccess
                .sink { [weak self] isSuccess in
                    if isSuccess == true {
                        self?.navigateToList()
                    }
                }.store(in: &bindings)

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
        print("onClick")
        viewModel.validateCredentials()
    }
    @objc private func didTapNewUser() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("DEBUG PRINT:", "didTapNewUser")
    }

    private func navigateToList() {
        //        let listViewController = ConversationViewController()
        //        navigationController?.pushViewController(listViewController, animated: true)
        let tabBarController = createTabBarController()

        //        let vc = RegisterViewController()
        //  UIApplication.shared.windows.first?.rootViewController = tabBarController
        //   self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.pushViewController(tabBarController, animated: true)
        print("DEBUG PRINT:", "navigateToList")

    }

    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        //  UITabBar.appearance().backgroundColor = .systemBlue
        tabBarController.viewControllers = [createFeedViewController(), createProfileViewController(), createBooksViewController()]
        return tabBarController

    }

    func createBooksViewController() -> UINavigationController {
//        let booksViewController = BooksViewController()
//        booksViewController.title = "Книги"
//        booksViewController.tabBarItem = UITabBarItem(title: "Книги", image: UIImage(systemName: "books.vertical"), tag: 1)
//        return UINavigationController(rootViewController: booksViewController)
        // Создание UIHostingController с ContentView
        let contentView = BooksViewController()
        let hostingController = UIHostingController(rootView: contentView)

        // Настройка заголовка и таб-бара
//        hostingController.title = "Книги"
      //  hostingController.navigationController?.navigationBar.isHidden = true


        hostingController.tabBarItem = UITabBarItem(title: "Книги", image: UIImage(systemName: "books.vertical"), tag: 1)

        // Возвращение UINavigationController с hostingController
        let navigationController = UINavigationController(rootViewController: hostingController)
              let appearance = UINavigationBarAppearance()
              appearance.configureWithOpaqueBackground()
              appearance.backgroundColor = .systemBackground
              navigationController.navigationBar.standardAppearance = appearance
              navigationController.navigationBar.scrollEdgeAppearance = appearance

              return navigationController
//        return UINavigationController(rootViewController: hostingController)

    }
    func createFeedViewController() -> UINavigationController {
        let feedViewController = ConversationsViewController()
        feedViewController.title = "Клубы"
        feedViewController.tabBarItem = UITabBarItem(title: "Клубы", image: UIImage(systemName: "person.3"), tag: 1)
        return UINavigationController(rootViewController: feedViewController)
    }
    func createProfileViewController() -> UINavigationController {

        let profileViewController = ProfileViewController()

        profileViewController.title = "Профиль"

        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)

        return UINavigationController(rootViewController: profileViewController)

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
