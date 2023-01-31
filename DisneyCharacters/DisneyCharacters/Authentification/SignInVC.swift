import UIKit
import Stevia
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignInVC: UIViewController {
    private let stackView = UIStackView()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let signInButton = UIButton()
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
        
        emailField.placeholder = "Email"
        emailField.borderStyle = .line
        
        passwordField.placeholder = "Password"
        passwordField.borderStyle = .line
        passwordField.isSecureTextEntry = true
        
        signInButton.text("Sign in")
        signInButton.setTitleColor(.blue, for: .normal)
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
        errorLabel.isHidden = true
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
            emailField
            passwordField
            signInButton
            errorLabel
        }
        
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.axis = .vertical
    }
    
    //MARK: - Action
    
    @objc private func didTapSignInButton() {
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else { return }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.errorLabel.text = error?.localizedDescription
            } else {
                let vc = HomeVC.create(networkService: DisneyNetwork())
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
