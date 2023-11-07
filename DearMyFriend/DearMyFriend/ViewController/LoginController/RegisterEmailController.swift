import UIKit

class RegisterEmailController: UIViewController {
    
    private var isKeyboardUp = false
    
    private let registerView = RegisterEmailView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupTextField()
        setupNavi()
        title = "이메일 생성"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.registerView.emailField.becomeFirstResponder()
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
        registerView.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    private func setupNavi() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = ThemeColor.deepPink
        self.navigationItem.leftBarButtonItem = backButton
    }
    
   
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        let registerEmail = self.registerView.emailField.text ?? ""
        let registerUser = RegisterUserRequest(email: registerEmail)
        let vc = RegisterPasswordController()
        vc.registerUser = registerUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func backButtonTapped() {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        self.view.addSubviews([registerView])
        
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            registerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegisterEmailController {
    
    @objc func keyboardUp(notification:NSNotification) {
        if !isKeyboardUp, let keyboardFrame:NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardUp = true
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.03, animations: {
                self.registerView.signInButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
            }
            )
        }
    }
    
    @objc func keyboardDown() {
        isKeyboardUp = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.registerView.signInButton.transform  = .identity
            }
        )
    }
}

extension RegisterEmailController : UITextFieldDelegate {
    
    func setupTextField() {
        self.registerView.emailField.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if Validator.isValidEmail(for: newText) {
            self.registerView.signInButton.validTrueColor()
            self.registerView.signInButton.isEnabled = true
        } else {
            self.registerView.signInButton.validFalseColor()
            self.registerView.signInButton.isEnabled = false
        }
        
        return true
    }
}

