// FeadViewController
// Add Post View
// 게시글을 추가하는 화면

import Foundation
import UIKit

protocol AddPostViewDelegate: AnyObject {
    func cancelButtonTapped()
    func uploadButtonTapped()
    func imageViewTapped()
}

class AddPostView: UIView {
    
    // MARK: Properties
    // Label & Button
    let userNicknameLabelSize: CGFloat = 20
    let buttonSize: CGFloat = 20
    let buttonImage: String = "xmark"
    let buttonColor: UIColor = .black
    var delegate: AddPostViewDelegate?
    // Image
    let imageName: String = "spider1"
    // TextView
    let postTextViewHeight: CGFloat = 100
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: userNicknameLabelSize)
        label.text = "사용자 닉네임" // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var uploadPostButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("공유", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: buttonSize)
        
        button.setTitleColor(buttonColor, for: .normal)
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancelPostButton: UIButton = {
        let button = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .light)
        let image = UIImage(systemName: buttonImage, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = buttonColor

        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: imageName)

        return imageView
    }()
    
    lazy var imagePickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var imageCollectionView: UICollectionView = {
        // collectionView layout setting
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal // 스크롤 방향 설정
        layout.minimumLineSpacing = 0 // 라인 간격
        layout.minimumInteritemSpacing = 0 // 항목 간격
        layout.footerReferenceSize = .zero // 헤더 사이즈 설정
        layout.headerReferenceSize = .zero // 푸터 사이즈 설정
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true // 스크롤 활성화
        collectionView.isPagingEnabled = true // 페이징 활성화
        collectionView.showsHorizontalScrollIndicator = false // 수평 스크롤바를 숨김.
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .yellow
        pageControl.pageIndicatorTintColor = .green
        
        return pageControl
    }()
    
    lazy var postTextView: UITextView = {
       let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        
        textView.backgroundColor = .blue
        textView.text = "Test 입니다."
        
        return textView
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
        [userNicknameLabel, uploadPostButton, cancelPostButton, postImageView, imagePickerButton, imageCollectionView, pageControl, postTextView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setCancelPostButtonConstraint()
        setAddPostButtonConstraint()
        setPostImageViewConstraint()
        setImageCollectionViewConstraint()
        setPostTextViewConstraint()
    }
    
    // MARK: - Constant
    // Button & Label
    let topViewHeight: CGFloat = 50
    let buttonSideConstant: CGFloat = 10
    // Image Collection
    let imageViewHeight: CGFloat = 300
    let imageCollectionTopConstant: CGFloat = 8
    let imageCollectionSideSpaceConstant: CGFloat = 16
    let imageCollectionViewHeight: CGFloat = 300
    let pageControlHeight: CGFloat = 30
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            userNicknameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            userNicknameLabel.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setCancelPostButtonConstraint() {
        NSLayoutConstraint.activate([
            cancelPostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cancelPostButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: buttonSideConstant),
            cancelPostButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setAddPostButtonConstraint() {
        NSLayoutConstraint.activate([
            uploadPostButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            uploadPostButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -buttonSideConstant),
            uploadPostButton.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setPostImageViewConstraint() {
        NSLayoutConstraint.activate([
            // image 표시 전
            postImageView.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            
            imagePickerButton.topAnchor.constraint(equalTo: postImageView.topAnchor),
            imagePickerButton.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor),
            imagePickerButton.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            imagePickerButton.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor)
        ])
    }
    
    private func setImageCollectionViewConstraint() {
        
        imageCollectionView.isHidden = true
        pageControl.isHidden = true
        
        NSLayoutConstraint.activate([
            // 선택된 이미지 표시
            imageCollectionView.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            
            pageControl.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: -pageControlHeight),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: pageControlHeight)
        ])
    }
    
    private func setPostTextViewConstraint() {
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postTextView.heightAnchor.constraint(equalToConstant: postTextViewHeight)
        ])
    }
    
    // MARK: - Action
    @objc private func cancelButtonTapped(){
        print("cancel 클릭")
        delegate?.cancelButtonTapped()
    }
    @objc private func uploadButtonTapped(){
        print("upload 클릭")
        delegate?.uploadButtonTapped()
    }
    
    @objc private func profileImageViewTapped(){
        print("image 클릭")
        delegate?.imageViewTapped()
    }
}
