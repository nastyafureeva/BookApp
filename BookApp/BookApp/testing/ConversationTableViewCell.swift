//
//  ConversationTableViewCell.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 02.06.2024.
//


import UIKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {

    static let identifier = "ConversationTableViewCell"

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()

    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userImageView.frame = CGRect(x: 10,
                                     y: 10,
                                     width: 100,
                                     height: 100)

        userNameLabel.frame = CGRect(x: userImageView.frame.maxX + 10,
                                     y: 10,
                                     width: contentView.frame.width - 20 - userImageView.frame.width,
                                     height: (contentView.frame.height-20)/2)

        userMessageLabel.frame = CGRect(x: userImageView.frame.maxX + 10,
                                        y: userNameLabel.frame.maxY + 10,
                                        width: contentView.frame.width - 20 - userImageView.frame.width,
                                        height: (contentView.frame.height-20)/2)

    }

    public func configure(with model: Conversation) {
        userMessageLabel.text = model.latestMessage.text
        userNameLabel.text = model.name
        let ss = AuthService.safeEmail(emailAddress: model.otherUserEmail)
        let path = "images/\(ss)_profile_picture.png"
        let pattt = "images/pict-gmail.com_profile_pic.png"
        print(path)
        StorageManager.shared.downloadURL(for: pattt, completion: { [weak self] result in
            switch result {
            case .success(let url):

                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }

            case .failure(let error):
                print("failed to get image url in cell: \(error)")
            }
        })
    }

}
