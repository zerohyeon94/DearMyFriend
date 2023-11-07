//
//  AgreementController.swift
//  DearMyFriend
//
//  Created by Macbook on 11/6/23.
//

import UIKit

class AgreementController: UIViewController {
    
    public var registerUser: RegisterUserRequest?
    
    private var isKeyboardUp = false
    
    private let registerView = AgreementView()
    
    lazy var checkList = [self.registerView.checkAll,
                          self.registerView.checkAge,
                          self.registerView.checkAgreement,
                          self.registerView.checkInformation]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupTapGestures()
        setupNavi()
        title = "약관동의"
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
    
    private func setupTapGestures() {
        var number = 1
        
        checkList.forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setupCheckGesture))
            $0.addGestureRecognizer(tapGesture)
            $0.isUserInteractionEnabled = true
            $0.tag = number
            number += 1
        }
    }
    
    // MARK: - Selectors
    @objc
    private func didTapSignIn() {
        self.registerView.activityIndicator.startAnimating()

        let registerAgreement = self.registerView.allCheckBool ? "전체동의" : "미동의"
        self.registerUser?.agreeMent = registerAgreement
        guard let registerAccount = self.registerUser else { return }
        AuthService.shared.registerUser(with: registerAccount) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                registerView.activityIndicator.stopAnimating()
                AlertManager.registerCheckAlert(on: self)
            }
            
            if wasRegistered {
                registerView.activityIndicator.stopAnimating()
                AuthService.shared.changeController(self)
            } else {
                registerView.activityIndicator.stopAnimating()
                AlertManager.registerCheckAlert(on: self)
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
        self.view.addSubviews([registerView])
        
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            registerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            registerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            registerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    @objc
    private func setupCheckGesture(sender: UITapGestureRecognizer) {
        
        if let view = sender.view {
            switch view.tag {
            case 1:
                self.registerView.allCheck()
            case 2, 3, 4:
                if let checkView = view as? CheckPasswordView {
                    checkView.changeColor()
                    if self.registerView.checkAll.colorBool == true {
                        self.registerView.checkAll.changeColor()
                        self.registerView.allCheckBool = false
                    }
                }
            default:
                break
            }
        }
        
        let completeList = checkList.filter {
            $0.colorBool == true
        }
        
        if completeList.count == 3 {
            self.registerView.checkAll.changeColor()
            self.registerView.allCheckBool = true
        }
        
        if self.registerView.allCheckBool == true {
            self.registerView.signInButton.validTrueColor()
            self.registerView.signInButton.isEnabled = true
        } else {
            self.registerView.signInButton.validFalseColor()
            self.registerView.signInButton.isEnabled = false

        }
    }
}
