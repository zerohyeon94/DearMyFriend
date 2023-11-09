
import UIKit

class RegisterPasswordView: UIView {
    
    let passwordField = SignTextField(fieldType: .password)
    
    let checkNumber = CheckPasswordView("8자리 이상", textSize.checkText)
    let checkIncludeNumber = CheckPasswordView("숫자 포함", textSize.checkText)
    let checkIncludeEnglish = CheckPasswordView("영문 포함", textSize.checkText)
    let checkIncludeCharacters = CheckPasswordView(#"특수 문자 포함(\,"제외)"#, textSize.checkText)
    
    lazy var checkListFirst: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [checkNumber, checkIncludeNumber])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    
    lazy var checkListSecond: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [checkIncludeEnglish, checkIncludeCharacters])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
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
            passwordField,
            checkListFirst,
            checkListSecond,
            signInButton,
        ])
        
        NSLayoutConstraint.activate([
            passwordField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            passwordField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            
            checkListFirst.topAnchor.constraint(equalTo: self.passwordField.bottomAnchor, constant: 10),
            checkListFirst.leadingAnchor.constraint(equalTo: self.passwordField.leadingAnchor),
            checkListFirst.heightAnchor.constraint(equalToConstant: 15),
            checkNumber.widthAnchor.constraint(equalTo: self.checkListSecond.widthAnchor, multiplier: 0.4),
            
            checkListSecond.topAnchor.constraint(equalTo: self.checkListFirst.bottomAnchor, constant: 10),
            checkListSecond.leadingAnchor.constraint(equalTo: self.passwordField.leadingAnchor),
            checkListSecond.heightAnchor.constraint(equalToConstant: 15),
            checkIncludeEnglish.widthAnchor.constraint(equalTo: self.checkListSecond.widthAnchor, multiplier: 0.4),
            
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
