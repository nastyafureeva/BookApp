//
//  AuthHeaderView.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 07.04.2024.
//

import UIKit

class AuthHeaderView: UIView {

    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()

    let logoRegisterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "person.circle")
        iv.tintColor = .brown
            //iv.layer.masksToBounds = false
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.brown.cgColor
        iv.layer.cornerRadius = iv.frame.size.width/2.0
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Error"
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.text = "Error"
        return label
    }()

    // MARK: - LifeCycle
    init(image: String, title: String, subTitle: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        switch image {
        case "logoImage":
            self.setupUI()
        case "logoRegister":
            self.setupUIRegister()
        default:
            return
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(logoImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 300),
            self.logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 19),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // MARK: - UI Setup
    private func setupUIRegister() {
        self.addSubview(logoRegisterImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)

        logoRegisterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        logoRegisterImageView.isUserInteractionEnabled = true
        logoRegisterImageView.layer.cornerRadius = logoRegisterImageView.frame.size.height / 2


        NSLayoutConstraint.activate([
            self.logoRegisterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            self.logoRegisterImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoRegisterImageView.widthAnchor.constraint(equalToConstant: 90),
            self.logoRegisterImageView.heightAnchor.constraint(equalTo: logoRegisterImageView.widthAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: logoRegisterImageView.bottomAnchor, constant: 19),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
