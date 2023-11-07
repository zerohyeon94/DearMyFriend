import Foundation
import UIKit

protocol CommentInputViewDelegate: AnyObject {
    func uploadButtonTapped()
}

class CommentInputView: UIView {
    
    // MARK: Properties
    // TextView
    let textViewFont: CGFloat = 15
    // Button
    let uploadCommentButtonSize: CGFloat = 30
    let uploadCommentButtonImage: String = "paperplane" // or arrow.up.circle
    let buttonColor: UIColor = ThemeColor.deepPink
    let buttonFrame: CGFloat = 50
    let buttonSize: CGFloat = 28
    let buttonPadding: CGFloat = 8
    
    var delegate: CommentInputViewDelegate?
    
    lazy var commentTextField: UITextField = {
       let textField = UITextField()
        
//        textField.isEditable = true
//        textField.isSelectable = true
        
        textField.font = UIFont.systemFont(ofSize: textViewFont)
        textField.placeholder = "게시글 작성"
        
        return textField
    }()
    
    lazy var uploadCommentButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: buttonFrame, height: buttonFrame)
        
        let resizedImage = FeedView().resizeUIImage(imageName: uploadCommentButtonImage, heightSize: buttonSize, tintColor: buttonColor)
        button.setImage(resizedImage, for: .normal)
        
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        // 패딩 설정
        let padding = UIEdgeInsets(top: buttonPadding, left: buttonPadding, bottom: buttonPadding, right: buttonPadding)
        button.contentEdgeInsets = padding
        
        return button
    }()
    
    // MARK: Initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI(){
        [commentTextField, uploadCommentButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setCommentTextViewConstraint()
        setCommentUploadButtonConstraint()
    }
    
    private func setCommentTextViewConstraint() {
        NSLayoutConstraint.activate([
            commentTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: uploadCommentButton.leadingAnchor),
            commentTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setCommentUploadButtonConstraint() {
        NSLayoutConstraint.activate([
            uploadCommentButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            uploadCommentButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor),
            uploadCommentButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            uploadCommentButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            uploadCommentButton.widthAnchor.constraint(equalToConstant: uploadCommentButtonSize + (buttonPadding * 2))
            
        ])
    }
    
    // MARK: Action
    @objc func uploadButtonTapped() {
        print("comment 창 종료")
        delegate?.uploadButtonTapped()
    }
}
