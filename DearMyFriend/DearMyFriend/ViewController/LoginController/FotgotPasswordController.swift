//
//  FotgotPasswordController.swift
//  DearMyFriend
//
//  Created by Macbook on 11/6/23.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    private var isKeyboardUp = false
    
    private let passwordResetView = ForgotPasswordView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupTextField()
        setupNavi()
        title = "비밀번호 찾기"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.passwordResetView.emailField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNavi() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = ThemeColor.deepPink
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Action Setup
    private func setupAction() {
        passwordResetView.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc private func didTapSignIn() {
        passwordResetView.activityIndicator.startAnimating()
        let userEmail = self.passwordResetView.emailField.text ?? ""
        AuthService.shared.forgotPassword(with: userEmail) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.passwordResetView.activityIndicator.stopAnimating()
                AlertManager.certificationCheckAlert(on: self, with: error)
                return
            } else {
                self.passwordResetView.activityIndicator.stopAnimating()
                AlertManager.certificationSuccessAlert(on: self)
            }
        }
    }
    
    @objc
    private func backButtonTapped() {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    private func setupUI() {
        self.view.addSubviews([passwordResetView])
        
        NSLayoutConstraint.activate([
            passwordResetView.topAnchor.constraint(equalTo: self.view.topAnchor),
            passwordResetView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            passwordResetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            passwordResetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ForgotPasswordController {
    
    @objc func keyboardUp(notification:NSNotification) {
        if !isKeyboardUp, let keyboardFrame:NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardUp = true
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.03, animations: {
                self.passwordResetView.signInButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
            }
            )
        }
    }
    
    @objc func keyboardDown() {
        isKeyboardUp = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.passwordResetView.signInButton.transform  = .identity
            }
        )
    }
}

extension ForgotPasswordController : UITextFieldDelegate {
    
    func setupTextField() {
        self.passwordResetView.emailField.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if Validator.isValidEmail(for: newText) {
            self.passwordResetView.signInButton.validTrueColor()
            self.passwordResetView.signInButton.isEnabled = true
        } else {
            self.passwordResetView.signInButton.validFalseColor()
            self.passwordResetView.signInButton.isEnabled = false
        }
        
        return true
    }
}

