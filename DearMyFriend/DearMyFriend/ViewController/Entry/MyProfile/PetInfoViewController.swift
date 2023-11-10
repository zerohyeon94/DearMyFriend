import UIKit
import Firebase
import FirebaseAuth

class PetInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var topHalfView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.5) // 연한 핑크색으로 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "camera")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var petNameTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(petNameTextField)
        view.addSubview(petNameInfoLabel)
        return view
    }()
    
    //
    private let petNameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "애완동물 이름"
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    
    
    private lazy var petNameTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
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
    
    
    private let petageInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "애완동물 나이"
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return label
    }()
    
    
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
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
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
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
        button.isEnabled = true // 버튼 기능 활성화
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
    lazy var petageInfoLabelCenterYConstraint = petageInfoLabel.centerYAnchor.constraint(equalTo: petageTextFieldView.centerYAnchor)
    lazy var petSpeciesInfoLabelCenterYConstraint = petSpeciesInfoLabel.centerYAnchor.constraint(equalTo: petSpeciesTextFieldView.centerYAnchor)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        configure()
        view.addSubview(profileImageView)
        self.view.addSubview(topHalfView)
        self.view.sendSubviewToBack(topHalfView)
        setupAutoLayout()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 상단 뷰의 모양을 파인 형태로 변경
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: topHalfView.bounds.height))
        path.addQuadCurve(to: CGPoint(x: 0, y: topHalfView.bounds.height), controlPoint: CGPoint(x: view.bounds.width / 2, y: topHalfView.bounds.height - 50))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        topHalfView.layer.mask = shapeLayer
    }
    
    // 셋팅
    private func configure() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        petNameTextField.delegate = self
        petageTextField.delegate = self
        petSpeciesTextField.delegate = self
        [stackView].forEach { view.addSubview($0) }
    }
    
    // 오토레이아웃
    private func setupAutoLayout() {
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        topHalfView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topHalfView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topHalfView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        topHalfView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        
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
        petageInfoLabelCenterYConstraint.isActive = true
        
        petageTextField.translatesAutoresizingMaskIntoConstraints = false
        petageTextField.topAnchor.constraint(equalTo: petageTextFieldView.topAnchor, constant: 15).isActive = true
        petageTextField.bottomAnchor.constraint(equalTo: petageTextFieldView.bottomAnchor, constant: -2).isActive = true
        petageTextField.leadingAnchor.constraint(equalTo: petageTextFieldView.leadingAnchor, constant: 8).isActive = true
        petageTextField.trailingAnchor.constraint(equalTo: petageTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        petSpeciesInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        petSpeciesInfoLabel.leadingAnchor.constraint(equalTo: petSpeciesTextFieldView.leadingAnchor, constant: 8).isActive = true
        petSpeciesInfoLabel.trailingAnchor.constraint(equalTo: petSpeciesTextFieldView.trailingAnchor, constant: -8).isActive = true
        petSpeciesInfoLabelCenterYConstraint.isActive = true
        
        petSpeciesTextField.translatesAutoresizingMaskIntoConstraints = false
        petSpeciesTextField.topAnchor.constraint(equalTo: petSpeciesTextFieldView.topAnchor, constant: 15).isActive = true
        petSpeciesTextField.bottomAnchor.constraint(equalTo: petSpeciesTextFieldView.bottomAnchor, constant: -2).isActive = true
        petSpeciesTextField.leadingAnchor.constraint(equalTo: petSpeciesTextFieldView.leadingAnchor, constant: 8).isActive = true
        petSpeciesTextField.trailingAnchor.constraint(equalTo: petSpeciesTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: textViewHeight*4 + 36).isActive = true
    }
    
    
    //애완동물나이 숫자만 입력기능
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == petageTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @objc func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.layer.cornerRadius = 100
            profileImageView.image = selectedImage
        }
    }
    
    @objc private func addButtonTapped() {
        guard let loginUser = Auth.auth().currentUser?.email else { return }
        
        let petDB = AuthService.shared
        
        // 네비게이션 컨트롤러를 사용하여 이전 화면으로 되돌아감
        let petName = petNameTextField.text ?? ""
        let petAge = petageTextField.text ?? ""
        let petspices = petSpeciesTextField.text ?? ""
        let petPhoto = profileImageView.image
        
        petDB.checkPetCount { count, error in
            if error != nil {
                print("카운트 에러 발생")
                return
            }
            
            guard let count = count else { return }
            
            let document = "myPet\(count)"
            petDB.photoUpdate(email: loginUser, photo: petPhoto, count) { error in
                if error != nil {
                    print("사진 업데이트 에러 발생")
                    return
                }
                
                petDB.getPhotoUrl(email: loginUser, count) { imageUrl, error in
                    if error != nil {
                        print("사진 업로드 주소 불러오기 실패")
                        return
                    }
                    
                    let myPet = RegisterMyPetInfo(name: petName, age: petAge, type: petspices, photoUrl: imageUrl)
                    
                    petDB.registerPet(with: myPet, document: document) { [weak self] error in
                        guard let self = self else { return }
                        if error != nil {
                            print("펫 문서생성 실패")
                            return
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
        
        
        print("추가하기 버튼 눌림")
        
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
            petageInfoLabelCenterYConstraint.constant = -13
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
                petNameInfoLabel.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
                petNameInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == petageTextField {
            petageTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if petageTextField.text == "" {
                petageInfoLabel.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
                petageInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == petSpeciesTextField {
            petSpeciesTextFieldView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            // 빈칸이면 원래로 되돌리기
            if petSpeciesTextField.text == "" {
                petSpeciesInfoLabel.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 18)
                petSpeciesInfoLabelCenterYConstraint.constant = 0
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
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
            let petname = petNameTextField.text, !petname.isEmpty,
            let petage = petageTextField.text, !petage.isEmpty,
            let petspecies = petSpeciesTextField.text, !petspecies.isEmpty
                
        else {
            addButton.backgroundColor = .clear
            addButton.isEnabled = false
            return
        }
        addButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.35) // 투명도를 0.3으로 설정
        
        addButton.isEnabled = true
    }
}
