import UIKit
import Stevia
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpVC: UIViewController {
    private let stackView = UIStackView()
    private let nameField = UITextField()
    private let surnameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let signUpButton = UIButton()
    private let errorLabel = UILabel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        view.backgroundColor = Palette.color(.lWhite_dDark)
        
        nameField.placeholder = "Name"
        nameField.borderStyle = .line
        
        surnameField.placeholder = "Surname"
        surnameField.borderStyle = .line
        
        emailField.placeholder = "Email"
        emailField.borderStyle = .line
        
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .line
        passwordField.isSecureTextEntry = true
        
        errorLabel.text = "Not correct password"
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        errorLabel.numberOfLines = 0
        
        signUpButton.text("Sign up")
        signUpButton.setTitleColor(.blue, for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.subviews {
            stackView
        }
        
        stackView.fillHorizontally(padding: 20)
        stackView.Top == view.safeAreaLayoutGuide.Top + 20
        
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.arrangedSubviews {
            nameField
            surnameField
            emailField
            passwordField
            signUpButton
            errorLabel
        }
        
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.axis = .vertical
    }
    
    //MARK: - Action
    
    @objc private func didTapSignUpButton() {
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else { return }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.isHidden = false
            } else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: [
                    "name": self.nameField.text,
                    "surname": self.surnameField.text,
                    "uid": result?.user.uid
                ]) { error in
                    if error != nil {
                        print("error: \(error)")
                    }
                    print("UID: \(result?.user.uid)")
                }
                let vc = HomeVC.create(networkService: DisneyNetwork())
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
