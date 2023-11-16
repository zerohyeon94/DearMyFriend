import UIKit
import PhotosUI

class RegisterProfileController: UIViewController {
    
    private var selectedImage: UIImage? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.registerView.pickerView.image = selectedImage
            }
        }
    }
    
    public var registerUser: RegisterUserRequest?
        
    private var isKeyboardUp = false
    
    private let registerView = RegisterProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupTapGestures()
        setupTextField()
        setupNavi()
        title = "프로필 생성"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerView.usernameField.becomeFirstResponder()
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
        let registerUsername = self.registerView.usernameField.text ?? ""
        registerUser?.username = registerUsername
        let vc = AgreementController()
        vc.myPhoto = self.selectedImage ?? UIImage(named: "userImage")
        vc.registerUser = self.registerUser
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
    
    private func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setupImagePicker))
        self.registerView.pickerView.addGestureRecognizer(tapGesture)
        self.registerView.pickerView.isUserInteractionEnabled = true
    }
}

extension RegisterProfileController {
    
    @objc func keyboardUp(notification:NSNotification) {
        if !isKeyboardUp, let keyboardFrame:NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardUp = true
            let keyboardRectangle = keyboardFrame.cgRectValue.height
            let keyboardHeight = keyboardRectangle * 1.1
            
            UIView.animate(withDuration: 0.03, animations: {
                self.registerView.signInButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
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

extension RegisterProfileController: PHPickerViewControllerDelegate {
    
    @objc
    private func setupImagePicker() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch photoAuthorizationStatus {
        case .authorized:
            openPhotoPicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.openPhotoPicker()
                    } else {
                        self.showPermissionDeniedAlert()
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert()
        default:
            break
        }
    }

    private func openPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    private func showPermissionDeniedAlert() {
        let alertController = UIAlertController(title: "알림", message: "사진 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
           picker.dismiss(animated: true)
           
           guard let result = results.first else {
               return
           }

           let itemProvider = result.itemProvider

           if itemProvider.canLoadObject(ofClass: UIImage.self) {
               // 수정된 부분: 이미지 데이터를 가져올 수 있는 경우
               itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                   DispatchQueue.main.async { [weak self] in
                       guard let self = self, let selectedImage = image as? UIImage else { return }
                       
                       self.registerView.pickerView.clipsToBounds = true
                       self.selectedImage = selectedImage
                   }
               }
           } else {
               AlertManager.errorAlert(on: self)
           }
       }
}

extension RegisterProfileController : UITextFieldDelegate {
    
    func setupTextField() {
        self.registerView.usernameField.delegate = self
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if Validator.isValidUsername(for: newText) {
            self.registerView.signInButton.validTrueColor()
            self.registerView.signInButton.isEnabled = true
        } else {
            self.registerView.signInButton.validFalseColor()
            self.registerView.signInButton.isEnabled = false
            
        }
        
        return true
    }
}

