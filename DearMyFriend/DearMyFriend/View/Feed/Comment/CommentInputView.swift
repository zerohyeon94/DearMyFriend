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
    let uploadCommentButtonColor: UIColor = .black
    
    var delegate: CommentInputViewDelegate?
    
    lazy var commentTextField: UITextView = {
       let textView = UITextView()
        
        textView.isEditable = true
        textView.isSelectable = true
        
        textView.font = UIFont.systemFont(ofSize: textViewFont)
        textView.text = "게시글 작성"
        
        return textView
    }()
    
    lazy var uploadCommentButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: uploadCommentButtonSize, weight: .light)
        let image = UIImage(systemName: uploadCommentButtonImage, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = uploadCommentButtonColor
        
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
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
        [commentTextField].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setCommentTextViewConstraint()
    }
    
    private func setCommentTextViewConstraint() {
        NSLayoutConstraint.activate([
            commentTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            commentTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Action
    @objc func uploadButtonTapped() {
        print("comment 창 종료")
        delegate?.uploadButtonTapped()
    }
}
