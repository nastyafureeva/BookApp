
import UIKit
import Combine

class RegisterViewController: UIViewController {
    private lazy var contentView = RegisterView()
    private let viewModel: RegisterViewModel
    private var bindings = Set<AnyCancellable>()
    init(viewModel: RegisterViewModel = RegisterViewModel()) {
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

        contentView.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        contentView.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        let geasture = UITapGestureRecognizer(target: self, action: #selector (didTapChangeProfile))
        contentView.headerView.logoRegisterImageView.addGestureRecognizer(geasture)
        //        contentView.headerView.logoRegisterImageView.layer.cornerRadius =   contentView.headerView.logoRegisterImageView.frame.size.width / 2
        //        contentView.headerView.logoRegisterImageView.clipsToBounds = true

    }

    private func setUpBindings() {
        func bindViewToViewModel() {
            contentView.usernameField.textPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.username, on: viewModel)
                .store(in: &bindings)

            contentView.emailField.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.email, on: viewModel)
                .store(in: &bindings)

            contentView.passwordField.textPublisher
                .receive(on: RunLoop.main)
                .assign(to: \.password, on: viewModel)
                .store(in: &bindings)
            contentView.headerView.logoRegisterImageView.publisher(for: \.image)
                .receive(on: RunLoop.main)
                .assign(to: \.image, on: viewModel)
                .store(in: &bindings)
        }

        func bindViewModelToView() {

            print("VALID")


            viewModel.$validationError
                .sink { [weak self] error in
                    if let error = error {
                        self?.showAlert(error: error)
                    } else {
                        if let sceneDelegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                        }
                    }
                }
                .store(in: &bindings)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }
    @objc private func didTapChangeProfile(){
        presentPhotoActionSheet()
    }
    @objc private func didTapSignUp() {
        viewModel.validateCredentials()
    }
    @objc private func didTapSignIn() {
        self.navigationController?.popToRootViewController(animated: true)
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
            print("REG \(errorDescription)")
            let alertController = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

            self?.presentCamera()

        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in

            self?.presentPhotoPicker()

        }))

        present(actionSheet, animated: true)
    }

    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        self.contentView.headerView.logoRegisterImageView.image = selectedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}


