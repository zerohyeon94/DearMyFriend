import UIKit

class CommentListView: UIView {
    
    private let maxLength = 15

    public let commentTable = UITableView()
    
    private let profileView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.image = FeedService.shared.userInfo?.profileImage
        view.clipsToBounds = true
        return view
    }()
    
    public let commentTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = ThemeColor.titleColor
        textField.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 18)
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.size.height))
        textField.clipsToBounds = true
        textField.backgroundColor = .clear
        textField.tintColor = .black
        let placeholderText = FeedService.shared.userInfo?.userName ?? ""
        textField.placeholder = "\(placeholderText)(으)로 댓글 달기"
        
        return textField
    }()
    
    private lazy var typingSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [spacerView1, profileView, commentTextField, spacerView2])
        sv.backgroundColor = .clear
        sv.spacing = 5
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    public lazy var commentSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [borderView, typingSV])
        sv.backgroundColor = .white
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let spacerView1 = UIView()
    private let spacerView2 = UIView()
    public let spacerView3: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    public lazy var sendButton: UIButton = {
        let configuration = UIButton.Configuration.buttonConfigurationWithImage(imageName: "paperplane.fill")
        
        let button = UIButton(configuration: configuration)
        button.tintColor = ThemeColor.titleColor
        button.isEnabled = false

        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoLayout()
        setupTextField()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 중간에 레이아웃 계산이 완료된 시점
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // 마지막 화면에 렌더링 되는 시점의 값
    override func draw(_ rect: CGRect) {
        self.profileView.layer.cornerRadius = self.profileView.frame.height/2
        self.commentTextField.layer.cornerRadius = self.commentTextField.frame.height/3
    }
    
    private func autoLayout() {
        self.addSubviews([commentTable, commentSV, sendButton, spacerView3])
        self.commentTable.backgroundColor = .white
        NSLayoutConstraint.activate([
            spacerView3.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            spacerView3.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            spacerView3.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            spacerView3.heightAnchor.constraint(equalToConstant: 25),
            
            commentSV.bottomAnchor.constraint(equalTo: self.spacerView3.topAnchor),
            commentSV.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            commentSV.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            commentSV.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/13),
            
            commentTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            commentTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            commentTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            commentTable.bottomAnchor.constraint(equalTo: self.commentSV.topAnchor),
            
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            spacerView1.widthAnchor.constraint(equalToConstant: 12),
            spacerView2.widthAnchor.constraint(equalToConstant: 12),
            
            profileView.widthAnchor.constraint(equalTo: self.profileView.heightAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalTo: commentTextField.heightAnchor),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)
        ])
    }
    
    private func setupTextField() {
        self.commentTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

extension CommentListView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 15
        let newLength = string.count
        let currentLength = (textField.text ?? "").count
        let exceedsLimit = (currentLength - range.length + newLength) > maxLength
        
        self.sendButton.isEnabled = !exceedsLimit && (currentLength + newLength > 0)
        
        return !exceedsLimit
    }
    
}
