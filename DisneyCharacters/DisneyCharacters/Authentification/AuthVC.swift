import UIKit
import Stevia

class AuthVC: UIViewController {
    private let stackView = UIStackView()
    private let signInButton = UIButton()
    private let signUpButton = UIButton()

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
        
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.text("SignUp")
        signUpButton.setTitleColor(.blue, for: .normal)
        
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        signInButton.text("SignIn")
        signInButton.setTitleColor(.blue, for: .normal)
    }
    
    private func setupLayout() {
        view.subviews {
            stackView
        }
        
        stackView.centerInContainer()
        
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.arrangedSubviews {
            signInButton
            signUpButton
        }
        
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.axis = .vertical
    }
    
    //MARK: - Action
    
    @objc private func didTapSignUpButton() {
        let vc = SignUpVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapSignInButton() {
        let vc = SignInVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
