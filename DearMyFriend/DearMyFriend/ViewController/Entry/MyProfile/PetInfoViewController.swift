import UIKit

class PetInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var mainViewController: TabBarController?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "camera") // 디폴트 이미지 설정
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var petNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "애완동물 이름"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var petAgeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "애완동물 나이"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var petTypeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "애완동물 종"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .orange
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        makeUI()
    }
    
    func makeUI() {
        view.addSubview(profileImageView)
        view.addSubview(petNameTextField)
        view.addSubview(petAgeTextField)
        view.addSubview(petTypeTextField)
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -230),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            petNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            petNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            petNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            petNameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            petAgeTextField.topAnchor.constraint(equalTo: petNameTextField.bottomAnchor, constant: 10),
            petAgeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            petAgeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            petAgeTextField.heightAnchor.constraint(equalToConstant: 45),
            
            petTypeTextField.topAnchor.constraint(equalTo: petAgeTextField.bottomAnchor, constant: 10),
            petTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            petTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            petTypeTextField.heightAnchor.constraint(equalToConstant: 45),
            
           
            addButton.widthAnchor.constraint(equalToConstant: 350),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            addButton.topAnchor.constraint(equalTo: petTypeTextField.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func profileImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
    }
    
    
    
    @objc func addButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
