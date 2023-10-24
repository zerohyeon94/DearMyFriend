



import UIKit

class LoginViewController: UIViewController {
    
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
          //  image.image = #imageLiteral(resourceName: "swift-logo")
            image.layer.cornerRadius = 50 // 이미지 객체의 모서리를 둥글게
            image.clipsToBounds = true    // 이미지 객체의 모서리를 둥글게
            return image
    }()
    
    private lazy var emailTextFieldView: UIView = {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            view.layer.cornerRadius = 5 // 뷰 객체의 모서리를 둥글게
            view.clipsToBounds = true   // 뷰 객체의 모서리를 둥글게

            // 뷰 객체(emailTextFieldView)에 emailTextField, emailInfoLabel 객체 올리기
            view.addSubview(emailTextField)  //emailTextField를 올리고
            view.addSubview(emailInfoLabel)  //emailTextField 위에 emailInfoLabel이 올라와야 함
            return view
        }()
    
    private var emailInfoLabel: UILabel = {
            var label = UILabel()
            label.text = "아이디"   //라벨 문구 설정
            label.font = UIFont.systemFont(ofSize: 18)  //라벨 폰트 크기 설정
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //라벨 폰트 색상을 흰색으로 설정
            return label
        }()
    
    private lazy var emailTextField: UITextField = {
            var textField = UITextField()
            textField.frame.size.height = 48    // textField의 높이 설정
            textField.backgroundColor = .clear  // textField의 배경색을 투명색으로 설정
            textField.textColor = .white
            textField.tintColor = .white  // textField를 눌렀을 때 흰색으로 살짝 변함
            textField.autocapitalizationType = .none  // 자동으로 입력값의 첫 번째 문자를 대문자로 변경
            textField.autocorrectionType = .no        // 틀린 글자가 있는 경우 자동으로 교정 (해당 기능은 off)
            textField.spellCheckingType = .no         // 스펠링 체크 기능 (해당 기능은 off)
            textField.keyboardType = .emailAddress    // 키보드 타입을 email 타입으로 설정
            return textField
        }()
    
    private lazy var passWordTextFieldView: UIView = {
            let view = UIView()
            view.frame.size.height = 48
            view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            view.layer.cornerRadius = 5
            view.clipsToBounds = true
           
            view.addSubview(passWordTextField)
            view.addSubview(passWordInfoLabel)
            view.addSubview(passWordSecureButton)
            return view
        }()
    
    private var passWordInfoLabel: UILabel = {
            var label = UILabel()
            label.text = "비밀번호"
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return label
        }()
    
    private lazy var passWordTextField: UITextField = {
            var textField = UITextField()
            textField.frame.size.height = 48  // 높이 설정
            textField.backgroundColor = .clear  // 투명색
            textField.textColor = .white
            textField.tintColor = .white  // passWordText를 눌렀을 때 흰색으로 살짝 변함
            textField.autocapitalizationType = .none  // 자동으로 입력값의 첫 번째 문자를 대문자로 변경
            textField.autocorrectionType = .no  // 틀린 글자가 있는 경우 자동으로 교정 (해당 기능은 off)
            textField.spellCheckingType = .no   // 스펠링 체크 기능 (해당 기능은 off)
            textField.isSecureTextEntry = true  // 비밀번호를 가리는 기능 (비밀번호 입력시 "ㆍㆍㆍ"으로 표시)
            textField.clearsOnBeginEditing = false  // 텍스트 필드 터치시 내용 삭제 (해당 기능은 off)
            return textField
        }()
    
    lazy var loginButton: UIButton = {
            var button = UIButton(type: .custom)
            button.setTitle("로그인", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.layer.borderWidth = 1   // 버튼의 테두리 두께 설정
            button.layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)  // 버튼의 테두리 색 설정
            button.isEnabled = false       // 버튼의 동작 설정 (처음에는 동작 off)
            return button
        }()
    
    private lazy var passWordSecureButton: UIButton = {
            var button = UIButton(type: .custom)
            button.setTitle("표시", for: .normal)        // 버튼 이름 설정
            button.setTitleColor(.white, for: .normal)  // 버튼 이름의 색상 설정
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)  // 버튼의 크기
            return button
        }()
    
    lazy var stackView: UIStackView = {
            // 배열을 사용하여 각각의 객체를 하나로 묶는 코드
            let stView = UIStackView(arrangedSubviews: [emailTextFieldView, passWordTextFieldView, loginButton])
           
            stView.spacing = 18      // 객체의 내부 간격 설정
            stView.axis = .vertical  // 세로 묶음으로 정렬 (가로 묶음은 horizontal)
            stView.distribution = .fillEqually  // 각 객체의 크기(간격) 분배 설정 (fillEqually: 여기서는 동일하게 분배)
            stView.alignment = .fill  // 정렬 설정 (fill: 전부 채우는 설정)
            return stView
        }()
       

    // + 각 텍스트필드 및 로그인 버튼의 높이 설정
    private let textViewHeight: CGFloat = 48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeUI()
        button()
        
    }
    
    private var joinbutton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .clear
            button.setTitle("회원가입", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
            view.backgroundColor = .black  // 메인 뷰 객체의 배경색을 변경
           
            // 메인 뷰 객체(ViewController)에 stackView, passWordResetButton, mainLoginImage 객체 올리기
            view.addSubview(stackView)
            view.addSubview(joinbutton)
            view.addSubview(mainLoginImage)
           
            // 사용자가 코드로 정의한 Auto Layout 기능 활성화
            mainLoginImage.translatesAutoresizingMaskIntoConstraints = false
            emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            passWordInfoLabel.translatesAutoresizingMaskIntoConstraints = false
            passWordTextField.translatesAutoresizingMaskIntoConstraints = false
            passWordSecureButton.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            joinbutton.translatesAutoresizingMaskIntoConstraints = false
           
            // NSLayoutConstraint.activate([뷰 객체의 위치 및 크기])배열 안에 뷰 객체의 위치와 크기를 설정
            NSLayoutConstraint.activate([
            // 로그인 화면 상단 이미지 위치 및 크기 설정
                mainLoginImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                mainLoginImage.bottomAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: -30),
                mainLoginImage.widthAnchor.constraint(equalToConstant: 100),
                mainLoginImage.heightAnchor.constraint(equalToConstant: 100),
               
            // 이메일 안내 문구 위치 설정
                emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
                emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8),
                emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor),
               
            // 이메일 텍스트 필드 위치 설정
                emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
                emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8),
                emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15),
                emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2),

            // 비밀번호 안내 문구 위치 설정
                passWordInfoLabel.leadingAnchor.constraint(equalTo: passWordTextFieldView.leadingAnchor, constant: 8),
                passWordInfoLabel.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: 8),
                passWordInfoLabel.centerYAnchor.constraint(equalTo: passWordTextFieldView.centerYAnchor),
               
            // 비밀번호 텍스트 필드 위치 설정
                passWordTextField.leadingAnchor.constraint(equalTo: passWordTextFieldView.leadingAnchor, constant: 8),
                passWordTextField.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: 8),
                passWordTextField.topAnchor.constraint(equalTo: passWordTextFieldView.topAnchor, constant: 15),
                passWordTextField.bottomAnchor.constraint(equalTo: passWordTextFieldView.bottomAnchor, constant: 2),
               
            // 비밀번호 재설정 위치 설정
                passWordSecureButton.topAnchor.constraint(equalTo: passWordTextFieldView.topAnchor, constant: 15),
                passWordSecureButton.bottomAnchor.constraint(equalTo: passWordTextFieldView.bottomAnchor, constant: -15),
                passWordSecureButton.trailingAnchor.constraint(equalTo: passWordTextFieldView.trailingAnchor, constant: -8),
               
            // 하나로 묶은 스택 뷰 위치 및 높이 설정
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                stackView.heightAnchor.constraint(equalToConstant: textViewHeight*3 + 36),  //stackView의 높이 설정
               
            // 비밀번호 재설정 위치 및 높이 설정
                joinbutton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
                joinbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                joinbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                joinbutton.heightAnchor.constraint(equalToConstant: textViewHeight)  //비밀번호 재설정 버튼 높이 설정
            ])
        }
    
    @objc func nextButtonTapped() {
        self.mainViewController?.login = true
        dismiss(animated: true)
    }
}

//    @objc private func textFieldEditingChanged(_ textField: UITextField) {
//    if textField.text?.count == 1 {
//        if textField.text?.first == " " {
//            textField.text = ""
//            return
//        }
//    }
//    guard
//        let email = emailTextField.text, !email.isEmpty,
//        let password = passwordTextField.text, !password.isEmpty
//    else {
//        loginButton.backgroundColor = .clear
//        loginButton.isEnabled = false
//        return
//    }
//    loginButton.backgroundColor = .yellow
//    loginButton.isEnabled = true
//}

