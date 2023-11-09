import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    weak var mainViewController: TabBarController?
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainLoginImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "catdog")
        return image
    }()
    
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.addSubview(emailTextField)
        view.addSubview(emailInfoLabel)
        return view
    }()
    
    private var emailInfoLabel: UILabel = {
        var label = UILabel()
        label.text = "아이디"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        var textField = UITextField()
        textField.frame.size.height = 50
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .emailAddress
        textField.delegate = self // 추가된 부분
        return textField
    }()
    
    private lazy var passWordTextFieldView: UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.addSubview(passWordTextField)
        view.addSubview(passWordInfoLabel)
        view.addSubview(passwordSecureButton)
        return view
    }()
    
    private var passWordInfoLabel: UILabel = {
        var label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return label
    }()
    
    private lazy var passWordTextField: UITextField = {
        var textField = UITextField()
        textField.frame.size.height = 48
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.isSecureTextEntry = true
        textField.clearsOnBeginEditing = false
        textField.delegate = self
        return textField
    }()
    
    
    
    lazy var loginButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        button.isEnabled = false
        return button
    }()
    
    private lazy var passwordSecureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("표시", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [emailTextFieldView, passWordTextFieldView, loginButton])
        stView.spacing = 18
        stView.axis = .vertical
        stView.distribution = .fillEqually
        stView.alignment = .fill
        return stView
    }()
    
    private let textViewHeight: CGFloat = 48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        makeUI()
        button()
       
    }
    
    private lazy var joinbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("회원가입", for: .normal)
        button.addTarget(self, action: #selector(joinbuttonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    func button() {
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 45),
            nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func makeUI(){
        view.addSubview(stackView)
        view.addSubview(joinbutton)
        view.addSubview(mainLoginImage)
        mainLoginImage.translatesAutoresizingMaskIntoConstraints = false
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passWordInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        passWordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordSecureButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        joinbutton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mainLoginImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLoginImage.bottomAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: -50),
            mainLoginImage.widthAnchor.constraint(equalToConstant: 190),
            mainLoginImage.heightAnchor.constraint(equalToConstant: 190),
            
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8),
            emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8),
            emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 2),
            emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2),
            
            passWordInfoLabel.leadingAnchor.constraint(equalTo: passWordTextFieldView.leadingAnchor, constant: 8),
            passWordInfoLabel.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: 8),
            passWordInfoLabel.centerYAnchor.constraint(equalTo: passWordTextFieldView.centerYAnchor),
            
            passWordTextField.leadingAnchor.constraint(equalTo: passWordTextFieldView.leadingAnchor, constant: 8),
            passWordTextField.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: 8),
            passWordTextField.topAnchor.constraint(equalTo: passWordTextFieldView.topAnchor, constant: 2),
            passWordTextField.bottomAnchor.constraint(equalTo: passWordTextFieldView.bottomAnchor, constant: 2),
            
            passwordSecureButton.topAnchor.constraint(equalTo: passWordTextFieldView.topAnchor, constant: 15),
            passwordSecureButton.bottomAnchor.constraint(equalTo: passWordTextFieldView.bottomAnchor, constant: -15),
            passwordSecureButton.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: -8),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: textViewHeight*3 + 36),
            joinbutton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            joinbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            joinbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            joinbutton.heightAnchor.constraint(equalToConstant: textViewHeight)
        ])
    }
    
    
    
    @objc func passwordSecureModeSetting() {
        passWordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func nextButtonTapped() {
        self.mainViewController?.login = true
        dismiss(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailInfoLabel.isHidden = true
        } else if textField == passWordTextField {
            passWordInfoLabel.isHidden = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailInfoLabel.isHidden = !textField.text!.isEmpty
        } else if textField == passWordTextField {
            passWordInfoLabel.isHidden = !textField.text!.isEmpty
        }
    }
    
    @objc func joinbuttonTapped(_ sender: UIButton) {
        
    // UserInfoViewController 인스턴스를 생성합니다.
    let userInfoVC = UserInfoViewController()
        userInfoVC.modalPresentationStyle = .fullScreen
        present(userInfoVC, animated: true)
    // 네비게이션 컨트롤러를 사용하여 UserInfoViewController를 push합니다.
    //self.navigationController?.pushViewController(userInfoVC, animated: true)
        print("회원가입버튼 눌림")
        
    }
}

