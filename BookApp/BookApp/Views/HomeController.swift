//
//  HomeVController.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 23.04.2024.
//

import UIKit

class HomeController: UIViewController {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        self.label.text = ""
    }

    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))

        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }

    @objc private func didTapLogout() {
        AuthService.shared.signOut{ [weak self] error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
                return
            }
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }

}
