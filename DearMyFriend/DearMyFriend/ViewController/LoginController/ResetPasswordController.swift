import UIKit

class ResetPasswordController: UIViewController {
    
    public var resetCode: String?
    
    private var isKeyboardUp = false
    
    private let resetPasswordView = ResetPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupTextField()
        title = "비밀번호 재설정"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetPasswordView.passwordField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Action Setup
    private func setupAction() {
        resetPasswordView.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        resetPasswordView.activityIndicator.startAnimating()
        guard let code = self.resetCode else { return }
        let newPassword = self.resetPasswordView.passwordField.text ?? ""
        AuthService.shared.resetPassword(with: code, newPassword: newPassword) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.resetPasswordView.activityIndicator.stopAnimating()
                AlertManager.certificationCheckAlert(on: self, with: error)
                return
            }
            self.resetPasswordView.activityIndicator.stopAnimating()
            AuthService.shared.changeController(self)
        }
    }
    
    
    private func setupUI() {
        self.view.addSubviews([resetPasswordView])
        
        NSLayoutConstraint.activate([
            resetPasswordView.topAnchor.constraint(equalTo: self.view.topAnchor),
            resetPasswordView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            resetPasswordView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            resetPasswordView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ResetPasswordController {
    
    @objc func keyboardUp(notification:NSNotification) {
        if !isKeyboardUp, let keyboardFrame:NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardUp = true
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.03, animations: {
                self.resetPasswordView.signInButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
            }
            )
        }
    }
    
    @objc func keyboardDown() {
        isKeyboardUp = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.resetPasswordView.signInButton.transform  = .identity
            }
        )
    }
}

extension ResetPasswordController : UITextFieldDelegate {
    
    func setupTextField() {
        self.resetPasswordView.passwordField.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if Validator.checkNumber(for: newText) {
            self.resetPasswordView.checkNumber.validTrueColor()
        } else {
            self.resetPasswordView.checkNumber.validFalseColor()
        }
        //
        if Validator.checkIncludingOfNumber(for: newText) {
            self.resetPasswordView.checkIncludeNumber.validTrueColor()
        } else {
            self.resetPasswordView.checkIncludeNumber.validFalseColor()
        }
        //
        if Validator.checkIncludingOfEnglish(for: newText) {
            self.resetPasswordView.checkIncludeEnglish.validTrueColor()
        } else {
            self.resetPasswordView.checkIncludeEnglish.validFalseColor()
        }
        //
        if Validator.checkIncludingOfCharacters(for: newText) {
            self.resetPasswordView.checkIncludeCharacters.validTrueColor()
        } else {
            self.resetPasswordView.checkIncludeCharacters.validFalseColor()
        }
        
        if Validator.isPasswordValid(for: newText) {
            self.resetPasswordView.signInButton.validTrueColor()
            self.resetPasswordView.signInButton.isEnabled = true
        } else {
            self.resetPasswordView.signInButton.validFalseColor()
            self.resetPasswordView.signInButton.isEnabled = false
        }
        
        return true
    }
}
