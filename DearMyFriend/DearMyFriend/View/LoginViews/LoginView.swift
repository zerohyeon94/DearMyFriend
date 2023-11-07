import UIKit
import Lottie

class LoginView: UIView {
    
    // MARK: - UI components
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loginAnimation")
        animation.loopMode = .loop
        return animation
    }()
    
    let emailField = SignTextField(fieldType: .email)
    let passwordField = SignTextField(fieldType: .password)
    
    let signInButton = SignButton(title: "로그인", hasBackground: true, fontSize: .big)
    let newUserButton = SignButton(title: "회원가입", fontSize: .thin)
    let forgotPasswordButton = SignButton(title: "비밀번호 찾기", fontSize: .thin)
    let dividing = SignButton(title: "|", fontSize: .thin)
    
    lazy var newUserAndForgotButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newUserButton, dividing, forgotPasswordButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
        
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubviews([
            animationView,
            emailField,
            passwordField,
            signInButton,
            newUserAndForgotButton,
            activityIndicator
        ])
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            animationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 222),
            
            emailField.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 12),
            emailField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            passwordField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            
            signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            
            newUserAndForgotButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            newUserAndForgotButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            newUserAndForgotButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            newUserAndForgotButton.heightAnchor.constraint(equalToConstant: 55),
            
            newUserButton.widthAnchor.constraint(equalTo: self.newUserAndForgotButton.widthAnchor, multiplier: 0.45),
            forgotPasswordButton.widthAnchor.constraint(equalTo: self.newUserAndForgotButton.widthAnchor, multiplier: 0.45),
            dividing.widthAnchor.constraint(equalTo: self.newUserAndForgotButton.widthAnchor, multiplier: 0.1),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func setupAnimation() {
        self.animationView.play()
    }
}
