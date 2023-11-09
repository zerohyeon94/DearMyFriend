import Foundation
import UIKit

class MyProfileInfoView: UIView {
    // MARK: Properties
    // ImageView
    let profileImageFrame: CGFloat = 100
    // Label
    let profileTitleLabelSize: CGFloat = 18
    let profileSubTitleLabelSize: CGFloat = 15
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: profileImageFrame, height: profileImageFrame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider1")
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = profileImageFrame / 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: profileTitleLabelSize)
        label.text = "사용자 닉네임"
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var userEmailLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: profileSubTitleLabelSize)
        label.text = "사용자 이메일"
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var userPetLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: profileSubTitleLabelSize)
        label.text = "00이와 00이의 친구"
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var postStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNicknameLabel, userEmailLabel, userPetLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
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
        [profileImageView, postStackView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setProfileImageConstraint()
        setProfileStackViewConstraint()
    }
    
    // MARK: - Constant
    // Profile Image
    let profileHeight: CGFloat = 100
    let profileWidth: CGFloat = 100
    
    private func setProfileImageConstraint() {
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: profileHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: profileWidth),
        ])
    }
    
    private func setProfileStackViewConstraint() {
        NSLayoutConstraint.activate([
            postStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            postStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
        ])
    }
    
    func setupUserProfile() {
        let userData = MyViewController.myProfileData
        
        userNicknameLabel.text = userData.nickname
        userEmailLabel.text = userData.id
        
        var petCount: String = ""
        for petIndex in 0..<userData.petName.count {
            if petIndex == 0 {
                petCount = "\(userData.petName[petIndex])"
            } else {
                petCount = "\(petCount)와 \(userData.petName[petIndex])"
            }
        }
        
        userPetLabel.text = "\(petCount)의 친구"
    }
}
