// FeadViewController
// Title View
// 사용자의 ID와 게시글을 작성하는 View
//
import Foundation
import UIKit

protocol FeadTitleViewDelegate: AnyObject {
    func addButtonTapped()
}

class FeedTitleView: UIView {
    
    // MARK: Properties
    // Label
    let userNicknameLabelSize: CGFloat = 20
    
    // Button
    let addPostButtonSize: CGFloat = 30
    let addPostButtonImage: String = "note.text.badge.plus"
    let addPostButtonColor: UIColor = ThemeColor.deepPink
    var delegate: FeadTitleViewDelegate?
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: userNicknameLabelSize)
//        label.font = UIFont.boldSystemFont(ofSize: userNicknameLabelSize)
        label.text = "피드 페이지" // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textColor = ThemeColor.deepPink
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var addPostButton: UIButton = {
        let button = UIButton()
        
        let resizedImage = FeedView().resizeUIImage(imageName: addPostButtonImage, heightSize: addPostButtonSize, tintColor: addPostButtonColor)
        button.setImage(resizedImage, for: .normal)
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
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
        [userNicknameLabel, addPostButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setAddPostButtonConstraint()
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userNicknameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            userNicknameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setAddPostButtonConstraint() {
        NSLayoutConstraint.activate([
            addPostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            addPostButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addPostButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Action
    @objc func addButtonTapped() {
        print("피드 데이터 추가")
        delegate?.addButtonTapped()
    }
}
