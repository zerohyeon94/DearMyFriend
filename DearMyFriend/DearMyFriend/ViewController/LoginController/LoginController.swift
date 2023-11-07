import UIKit

class LoginController: UIViewController {
    
    private let authManager = AuthService.shared
    private var emailText:String?
    private var passwordText:String?
    private var keyBoardHeight:CGFloat?
    
    private let loginView = LoginView()
    private var isKeyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupAction()
        self.setupTextfield()
        setupUI()
        print("로그인뷰",StorageService.shared.bannerUrl)
        title = "로그인"
    }
    
    private func setupUI() {
        self.view.addSubviews([loginView])
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Action Setup
    private func setupAction() {
        loginView.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        loginView.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        loginView.activityIndicator.startAnimating()
        let loginRequest = LoginUserRequest(email: self.loginView.emailField.text ?? ""
                                            , password: self.loginView.passwordField.text ?? "")
        
        authManager.signIn(with: loginRequest) { [weak self] userCheck ,error in
            guard let self = self else { return }
            
            if let error = error {
                self.loginView.activityIndicator.stopAnimating()
                AlertManager.loginFailedAlert(on: self)
                return
            }
            
            if userCheck {
                self.loginView.activityIndicator.stopAnimating()
                authManager.changeController(self)
            } else {
                authManager.certificationCheck { error in
                    if let error = error {
                        self.loginView.activityIndicator.stopAnimating()
                        AlertManager.certificationCheckAlert(on: self, with: error)
                        return
                    } else {
                        self.loginView.activityIndicator.stopAnimating()
                        AlertManager.certificationSuccessAlert(on: self)
                    }
                }
            }
        }
    }
    
    
    @objc private func didTapNewUser() {
        self.view.endEditing(true)
        let vc = RegisterEmailController()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func didTapForgotPassword() {
        self.view.endEditing(true)
        let vc = ForgotPasswordController()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if !isKeyboardUp, let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue.origin.y // 키보드의 상단 Y좌표
            let buttonMaxY = self.loginView.newUserAndForgotButton.frame.maxY // 가장 하단의 UI의 하단 Y좌표
            
            if keyBoardHeight == nil {
                keyBoardHeight = keyboardRectangle - buttonMaxY // 키보드(Y)에서 하단UI(Y)를 뺀다 (음수가 나와야 함)
            }
            
            guard let distance = keyBoardHeight else { return }
            
            if distance < 0 { // 음수가 나왔을 때만 y: -distance 올려준다.
                isKeyboardUp = true
                UIView.animate(
                    withDuration: 0.3
                    , animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: distance-25)
                    }
                )
            }
        }
    }
    
    @objc func keyboardDown() {
        print("test")
        isKeyboardUp = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.view.transform = .identity
                print(self.view.transform)
            }
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension LoginController: UITextFieldDelegate {
    
    func setupTextfield() {
        self.loginView.emailField.delegate = self
        self.loginView.passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginView.emailField {
            self.loginView.passwordField.becomeFirstResponder()
        } else if textField == self.loginView.passwordField {
            self.didTapSignIn()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
        case self.loginView.emailField:
            self.emailText = newText
        case self.loginView.passwordField:
            self.passwordText = newText
        default:
            break
        }

        if Validator.isValidEmail(for: self.emailText ?? "")
            && Validator.isPasswordValid(for: self.passwordText ?? "") {
            self.loginView.signInButton.validTrueColor()
            self.loginView.signInButton.isEnabled = true
        } else {
            self.loginView.signInButton.validFalseColor()
            self.loginView.signInButton.isEnabled = false
        }
        
        return true
    }
}

// view = 내가 만든 뷰
// view.add
// 위 두개의 차이로 인해서 위치변경이 자유롭지 못했다. 이 점을 알려달라
