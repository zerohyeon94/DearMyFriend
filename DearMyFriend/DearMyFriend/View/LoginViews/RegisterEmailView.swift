
import UIKit

class RegisterEmailView: UIView {
    
    let emailField = SignTextField(fieldType: .email)
    
    private let informationText: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13)
        label.text = "가입완료 후 기입된 이메일로 인증메일이 발송됩니다."
        return label
    }()
    
    let signInButton = SignButton(title: "다음", hasBackground: true, fontSize: .complete)
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubviews([
            emailField,
            informationText,
            signInButton,
        ])
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            emailField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            
            informationText.topAnchor.constraint(equalTo: self.emailField.bottomAnchor, constant: 10),
            informationText.leadingAnchor.constraint(equalTo: self.emailField.leadingAnchor, constant: 10),
            
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
