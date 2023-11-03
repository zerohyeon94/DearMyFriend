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
    // Image View
    let imagePlusLabelSize: CGFloat = 15
    let imageName: String = "photo.badge.plus"
    // post label & TextView
    let postLabelFontSize: CGFloat = 18
    let textViewFont: CGFloat = 15
    
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
    
    lazy var imagePlusView: UIView = {
        let view = UIView()
        
        view.addSubview(postImageStackView)
        postImageStackView.translatesAutoresizingMaskIntoConstraints = false
        postImageStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: imageName)
        
        return imageView
    }()
    
    lazy var postImageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: imagePlusLabelSize)
        label.text = "사진을 추가해주세요."
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var postImageStackView: UIStackView = {
       let stackView = UIStackView()
        
        stackView.spacing = 1
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(postImageView)
        stackView.addArrangedSubview(postImageLabel)
        
        return stackView
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
    
    lazy var postLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: postLabelFontSize)
        label.text = "게시글"
        label.textAlignment = .left
        
        return label
    }()
    
    let borderView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(hexCode: "dee2e6", alpha: 1)
        return view
    }()
    
    lazy var postTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        
//        textView.layer.borderWidth = 1.0
//        textView.layer.borderColor = UIColor.gray.cgColor
//        textView.layer.cornerRadius = 5.0
        
        textView.font = UIFont.systemFont(ofSize: textViewFont)
        textView.text = "게시글 작성"
        
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
        [userNicknameLabel, uploadPostButton, cancelPostButton, imagePlusView, imagePickerButton, imageCollectionView, pageControl, postLabel, borderView, postTextView].forEach { view in
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
        setPostLabelConstraint()
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
    // TextView
    let postTextViewHeight: CGFloat = 100
    let bolderViewTopConstant: CGFloat = 10
    let textViewTopConstant: CGFloat = 10
    let sideSpaceConstant: CGFloat = 16
    
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
            imagePlusView.topAnchor.constraint(equalTo: userNicknameLabel.bottomAnchor),
            imagePlusView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imagePlusView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            imagePlusView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            
            imagePickerButton.topAnchor.constraint(equalTo: imagePlusView.topAnchor),
            imagePickerButton.leadingAnchor.constraint(equalTo: imagePlusView.leadingAnchor),
            imagePickerButton.trailingAnchor.constraint(equalTo: imagePlusView.trailingAnchor),
            imagePickerButton.bottomAnchor.constraint(equalTo: imagePlusView.bottomAnchor)
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
    
    private func setPostLabelConstraint() {
        NSLayoutConstraint.activate([
            postLabel.topAnchor.constraint(equalTo: imagePlusView.bottomAnchor, constant: textViewTopConstant),
            postLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideSpaceConstant),
            postLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideSpaceConstant),
//            postLabel.heightAnchor.constraint(equalToConstant: postTextViewHeight),
            
            borderView.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: bolderViewTopConstant),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideSpaceConstant),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideSpaceConstant),
            borderView.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
    
    private func setPostTextViewConstraint() {
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: textViewTopConstant),
            postTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideSpaceConstant),
            postTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideSpaceConstant),
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
