//
//  SceneDelegate.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 03.04.2024.
//
import SwiftUI
import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    // swiftlint:disable:next line_length
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        self.setupWindow(with: scene)
        self.checkAuthentication()
    }

    private func setupWindow(with scene: UIScene){
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }

    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            self.goToController(with: LoginViewController())
        } else {
            let tabBarController = createTabBarController()
            self.goToController(with: tabBarController)
            //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()

        //  UITabBar.appearance().backgroundColor = .systemBlue
        tabBarController.viewControllers = [createFeedViewController(), createProfileViewController(), createBooksViewController()]
        return tabBarController

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

    func createBooksViewController() -> UIViewController {
        let contentView = BooksViewController()
        let hostingController = UIHostingController(rootView: contentView)
        hostingController.tabBarItem = UITabBarItem(title: "Книги", image: UIImage(systemName: "books.vertical"), tag: 1)
        return hostingController
    }
    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0

            } completion: { [weak self] _ in

                let nav = UINavigationController(rootViewController: viewController)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                nav.setNavigationBarHidden(true, animated: false)
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }

}
