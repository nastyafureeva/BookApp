//
//  ProfileViewController.swift
//  BookApp
//
//  Created by Анастасия Фуреева on 26.05.2024.
//

import UIKit
import FirebaseAuth


final class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    let tableView = UITableView()

    //  var data = [ProfileViewModel]()
    var data = ["Log Out"]


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        // Настройка ограничений для tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        let controller = self
        tableView.tableHeaderView = createTableHeader(controller: controller)
    }

    func createTableHeader(controller: ProfileViewController) -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeEmail = AuthService.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_pic.png"
        let path = "images/"+filename

        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: controller.view.frame.width,
                                              height: 300))
        headerView.backgroundColor = .link

        let imageView = UIImageView(frame: CGRect(x: (headerView.frame.width-150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width/2
        headerView.addSubview(imageView)

        print(path)

        StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
            switch result {
            case .success(let url):
                print(url)
                self?.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })

        return headerView
    }

    func downloadImage(imageView: UIImageView, url: URL){
        print("downloadImage run")
        URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else{
                return
            }

            DispatchQueue.main.async{
                let image = UIImage(data: data)
                imageView.image = image
                self.tableView.reloadData()
            }
        }).resume()
    }
}

extension ProfileViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  let viewModel = data[indexPath.row]
        //   let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier,
        //                                          for: indexPath) as! ProfileTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) //
        cell.textLabel?.text =  data[indexPath.row]
        cell.textLabel?.textColor = .red
        cell.textLabel?.textAlignment = .center
        // cell.setUp(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // data[indexPath.row].handler?()
        let strongSelf = self
        let actionSheet = UIAlertController(title: "",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { [weak self] _ in

            guard let strongSelf = self else {
                return
            }

            do {
                try AuthService.shared.signOut() { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        print("SignOUT error: \(error)")
                    }
                    print("Success to log out")
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.setNavigationBarHidden(true, animated: false)
                    nav.modalPresentationStyle = .fullScreen
                    strongSelf.present(nav, animated: true)
                }
            }
            catch {
                print("Failed to log out")
            }

        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))

        strongSelf.present(actionSheet, animated: true)
    }
}


