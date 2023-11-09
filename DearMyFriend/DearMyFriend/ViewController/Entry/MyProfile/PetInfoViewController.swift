//
//  ViewController.swift
//  LoginProject
//
//  Created by Allen H on 2021/12/05.
//

import UIKit

class PetInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
    
    private lazy var petNameTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(petNameTextField)
        view.addSubview(petNameInfoLabel)
        return view
    }()
    
    // "이메일 또는 전화번호" 안내문구
    private let petNameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "애완동물 이름"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    // 로그인 - 이메일 입력 필드
    private lazy var petNameTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    
    
    private lazy var petageTextFieldView: UIView = {
        let view = UIView()
        //view.frame.size.height = 48
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(petageTextField)
        view.addSubview(petageInfoLabel)
        return view
    }()
    
    // 패스워드텍스트필드의 안내문구
    private let petageInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "애완동물 나이"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    // 로그인 - 비밀번호 입력 필드
    private lazy var petageTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = false
        tf.clearsOnBeginEditing = false
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    private lazy var petSpeciesTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(petSpeciesTextField)
        view.addSubview(petSpeciesInfoLabel)
        return view
    }()

    // "애완동물 종" 안내문구
    private let petSpeciesInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "애완동물 종"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()

    // 애완동물 종 입력 필드
    private lazy var petSpeciesTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()

    
  
    
    // MARK: - 로그인버튼
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = true
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // 이메일텍스트필드, 패스워드, 로그인버튼 스택뷰에 배치
    private lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [petNameTextFieldView, petageTextFieldView, petSpeciesTextFieldView, addButton])
        stview.spacing = 18
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    
    
    
    // 3개의 각 텍스트필드 및 로그인 버튼의 높이 설정
    private let textViewHeight: CGFloat = 48
    
    // 오토레이아웃 향후 변경을 위한 변수(애니메이션)
    lazy var petNameInfoLabelCenterYConstraint = petNameInfoLabel.centerYAnchor.constraint(equalTo: petNameTextFieldView.centerYAnchor)
    lazy var passwordInfoLabelCenterYConstraint = petageInfoLabel.centerYAnchor.constraint(equalTo: petageTextFieldView.centerYAnchor)
    lazy var petSpeciesInfoLabelCenterYConstraint = petageInfoLabel.centerYAnchor.constraint(equalTo: petSpeciesTextFieldView.centerYAnchor)
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        configure()
        setupAutoLayout()
        
        
    }
    
    // 셋팅
    private func configure() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        petNameTextField.delegate = self
        petageTextField.delegate = self
        [stackView].forEach { view.addSubview($0) }
    }
    
    // 오토레이아웃
    private func setupAutoLayout() {
        
        petNameInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        petNameInfoLabel.leadingAnchor.constraint(equalTo: petNameTextFieldView.leadingAnchor, constant: 8).isActive = true
        petNameInfoLabel.trailingAnchor.constraint(equalTo: petNameTextFieldView.trailingAnchor, constant: -8).isActive = true
        petNameInfoLabelCenterYConstraint.isActive = true
        
        petNameTextField.translatesAutoresizingMaskIntoConstraints = false
        petNameTextField.topAnchor.constraint(equalTo: petNameTextFieldView.topAnchor, constant: 15).isActive = true
        petNameTextField.bottomAnchor.constraint(equalTo: petNameTextFieldView.bottomAnchor, constant: -2).isActive = true
        petNameTextField.leadingAnchor.constraint(equalTo: petNameTextFieldView.leadingAnchor, constant: 8).isActive = true
        petNameTextField.trailingAnchor.constraint(equalTo: petNameTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        petageInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        petageInfoLabel.leadingAnchor.constraint(equalTo: petageTextFieldView.leadingAnchor, constant: 8).isActive = true
        petageInfoLabel.trailingAnchor.constraint(equalTo: petageTextFieldView.trailingAnchor, constant: -8).isActive = true
        passwordInfoLabelCenterYConstraint.isActive = true
        
        
        petageTextField.translatesAutoresizingMaskIntoConstraints = false
        petageTextField.topAnchor.constraint(equalTo: petageTextFieldView.topAnchor, constant: 15).isActive = true
        petageTextField.bottomAnchor.constraint(equalTo: petageTextFieldView.bottomAnchor, constant: -2).isActive = true
        petageTextField.leadingAnchor.constraint(equalTo: petageTextFieldView.leadingAnchor, constant: 8).isActive = true
        petageTextField.trailingAnchor.constraint(equalTo: petageTextFieldView.trailingAnchor, constant: -8).isActive = true
        //
        petSpeciesInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        petSpeciesInfoLabel.leadingAnchor.constraint(equalTo: petageTextFieldView.leadingAnchor, constant: 8).isActive = true
        petSpeciesInfoLabel.trailingAnchor.constraint(equalTo: petageTextFieldView.trailingAnchor, constant: -8).isActive = true
        petSpeciesInfoLabelCenterYConstraint.isActive = true
        
        petageTextField.translatesAutoresizingMaskIntoConstraints = false
        petageTextField.topAnchor.constraint(equalTo: petageTextFieldView.topAnchor, constant: 15).isActive = true
        petageTextField.bottomAnchor.constraint(equalTo: petageTextFieldView.bottomAnchor, constant: -2).isActive = true
        petageTextField.leadingAnchor.constraint(equalTo: petageTextFieldView.leadingAnchor, constant: 8).isActive = true
        petageTextField.trailingAnchor.constraint(equalTo: petageTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: textViewHeight*4 + 36).isActive = true
        
        
       
        
    }
    
    @objc private func addButtonTapped() {
            // 네비게이션 컨트롤러를 사용하여 이전 화면으로 되돌아감
            navigationController?.popViewController(animated: true)
        
        print("추가하기 버튼 눌림")
        
        }
    
    
    
    
    // 리셋버튼이 눌리면 동작하는 함수
    @objc func resetButtonTapped() {
        //만들기
        let alert = UIAlertController(title: "비밀번호 바꾸기", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert)
        let success = UIAlertAction(title: "확인", style: .default) { action in
            print("확인버튼이 눌렸습니다.")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소버튼이 눌렸습니다.")
        }
        
        alert.addAction(success)
        alert.addAction(cancel)
        
        // 실제 띄우기
        self.present(alert, animated: true, completion: nil)
    }
    
    // 앱의 화면을 터치하면 동작하는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension PetInfoViewController: UITextFieldDelegate {
    // MARK: - 텍스트필드 편집 시작할때의 설정 - 문구가 위로올라가면서 크기 작아지고, 오토레이아웃 업데이트
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == petNameTextField {
            petNameTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            petNameInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            petNameInfoLabelCenterYConstraint.constant = -13
        }
        
        if textField == petageTextField {
            petageTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            petageInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            passwordInfoLabelCenterYConstraint.constant = -13
        }
        
        if textField == petSpeciesTextField {
            petSpeciesTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            petSpeciesInfoLabel.font = UIFont.systemFont(ofSize: 11)
            // 오토레이아웃 업데이트
            petSpeciesInfoLabelCenterYConstraint.constant = -13
        }
        // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
    
    // 텍스트필드 편집 종료되면 백그라운드 색 변경 (글자가 한개도 입력 안되었을때는 되돌리기)
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == petNameTextField {
            petNameTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if petNameTextField.text == "" {
                petNameInfoLabel.font = UIFont.systemFont(ofSize: 18)
                petNameInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == petageTextField {
            petageTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if petageTextField.text == "" {
                petageInfoLabel.font = UIFont.systemFont(ofSize: 18)
                passwordInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == petSpeciesTextField {
            petSpeciesTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if petSpeciesTextField.text == "" {
                petSpeciesInfoLabel.font = UIFont.systemFont(ofSize: 18)
                petSpeciesInfoLabelCenterYConstraint.constant = 0
                // 실제 레이아웃 변경은 애니메이션으로 줄꺼야
                UIView.animate(withDuration: 0.3) {
                    self.stackView.layoutIfNeeded()
                }
            }
        }
    }
    

    // MARK: - 이메일텍스트필드, 비밀번호 텍스트필드 두가지 다 채워져 있을때, 로그인 버튼 빨간색으로 변경
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = petNameTextField.text, !email.isEmpty,
            let password = petageTextField.text, !password.isEmpty
        else {
            addButton.backgroundColor = .clear
            addButton.isEnabled = false
            return
        }
        addButton.backgroundColor = .systemPink
        addButton.isEnabled = true
    }
    
    
    // 엔터 누르면 일단 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
