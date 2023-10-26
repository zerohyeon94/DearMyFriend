// FeedViewController
// Feed View
// Feed 화면에서 게시글을 보여주는 View
// 해당 View는 FeedViewController에서 TableView에 들어가는 Cell에 들어갈 View 이다.

import Foundation
import UIKit

protocol FeedViewDelegate: AnyObject {
    func likeButtonTapped()
    func commentButtonTapped()
}

class FeedView: UIView {
    // MARK: Properties
    var delegate: FeedViewDelegate?
    // ImageView
    let profileImageFrame: CGFloat = 40
    // Label
    let userNicknameLabelSize: CGFloat = 18
    // Image CollectionView & Page Control
    let imageNames: [String] = ["spider1", "spider2", "spider3"]
    // Like & Comment Button
    let buttonFrame: CGFloat = 50
    let buttonSize: CGFloat = 28
    let buttonPadding: CGFloat = 8
    let likeButtonImage: String = "heart"
    let likeButtonColor: UIColor = .black
    let commentButtonImage: String = "message"
    let commentButtonColor: UIColor = .black
    // like ImageView & Label
    let likeImageFrame: CGFloat = 20
    let likelabelSize: CGFloat = 15
    // TextView
    let textViewFont: CGFloat = 15
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: profileImageFrame, height: profileImageFrame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider1")
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: userNicknameLabelSize)
        label.text = "사용자 닉네임" // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textAlignment = .left
        
        return label
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
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: buttonFrame, height: buttonFrame) // image Button 크기 지정.
        
        let resizedImage = resizeUIImage(imageName: likeButtonImage, heightSize: buttonSize)
        button.setImage(resizedImage, for: .normal)
        
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        // 패딩 설정
        let padding = UIEdgeInsets(top: buttonPadding, left: buttonPadding, bottom: buttonPadding, right: buttonPadding)
        button.contentEdgeInsets = padding
        
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: buttonFrame, height: buttonFrame)
        
        let resizedImage = resizeUIImage(imageName: commentButtonImage, heightSize: buttonSize)
        button.setImage(resizedImage, for: .normal)
        
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        
        // 패딩 설정
        let padding = UIEdgeInsets(top: buttonPadding, left: buttonPadding, bottom: buttonPadding, right: buttonPadding)
        button.contentEdgeInsets = padding
        
        return button
    }()
    
    lazy var like1ImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: likeImageFrame, height: likeImageFrame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider1")
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = likeImageFrame / 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var like2ImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: likeImageFrame, height: likeImageFrame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider2")
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = likeImageFrame / 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var like3ImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: likeImageFrame, height: likeImageFrame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider3")
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = likeImageFrame / 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: likelabelSize, weight: .medium)
        label.text = "조영현님 외 5명이 좋아합니다." // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var postTextView: UITextView = {
        let textView = UITextView()
        
        textView.isEditable = false
        textView.isSelectable = true // TextView 내의 Text를 선택하고 복사 여부.
        
        textView.font = UIFont.systemFont(ofSize: textViewFont)
        textView.text = "게시글을 받아오는 경우"
        
        return textView
    }()
    
    // MARK: Initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        calFeedViewHeight()
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
        [profileImageView, userNicknameLabel, imageCollectionView, pageControl, likeButton, commentButton, like1ImageView, like2ImageView, like3ImageView, likeLabel,  postTextView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setProfileImageViewConstraint()
        setNicknameLabelConstraint()
        setImageCollectionViewConstraint()
        setPageControlConstraint()
        setLikeButtonConstraint()
        setCommentButtonConstraint()
        setLikeImageViewConstraint()
        setLikeLabelConstraint()
        setPostTextViewConstraint()
    }
    
    // MARK: - Constant
    // Profile Image
    let profileHeight: CGFloat = 40
    let profileWidth: CGFloat = 40
    let profileLeadingConstant: CGFloat = 0
    // Nickname Label
    let topViewHeight: CGFloat = 40
    let userNicknameLeadingConstant: CGFloat = 12
    // Image Collection
    let imageCollectionTopConstant: CGFloat = 8
    let imageCollectionSideSpaceConstant: CGFloat = 16
    let imageCollectionViewHeight: CGFloat = 300
    let pageControlHeight: CGFloat = 30
    // Like & Comment Button
    let likeLeadingConstant: CGFloat = 0
    // like ImageView & Label
    let likeImageViewLeadingConstant: CGFloat = 6
    let likeImageViewBetweenConstant: CGFloat = 4
    let likeImageViewLabelHeight: CGFloat = 20
    let likeImageViewWidth: CGFloat = 20
    let likeLabelLeadingConstant: CGFloat = 4
    // post TextView
    let postTextViewTopConstant: CGFloat = 8
    let postTextViewHeight: CGFloat = 100
    
    private func setProfileImageViewConstraint() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: profileLeadingConstant),
            profileImageView.heightAnchor.constraint(equalToConstant: profileHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: profileWidth)
        ])
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            userNicknameLabel.topAnchor.constraint(equalTo: topAnchor),
            userNicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: userNicknameLeadingConstant),
            userNicknameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            userNicknameLabel.heightAnchor.constraint(equalToConstant: topViewHeight)
        ])
    }
    
    private func setImageCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: imageCollectionTopConstant),
            imageCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -imageCollectionSideSpaceConstant),
            imageCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: imageCollectionSideSpaceConstant),
            imageCollectionView.heightAnchor.constraint(equalToConstant: imageCollectionViewHeight),
        ])
    }
    
    private func setPageControlConstraint() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: -pageControlHeight),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: pageControlHeight)
        ])
    }
    
    private func setLikeButtonConstraint() {
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: likeLeadingConstant),
        ])
    }
    
    private func setCommentButtonConstraint() {
        NSLayoutConstraint.activate([
            commentButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor),
        ])
    }
    
    private func setLikeImageViewConstraint() {
        NSLayoutConstraint.activate([
            like1ImageView.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
            like1ImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: likeImageViewLeadingConstant),
            like1ImageView.heightAnchor.constraint(equalToConstant: likeImageViewLabelHeight),
            like1ImageView.widthAnchor.constraint(equalToConstant: likeImageViewWidth),
            
            like2ImageView.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
            like2ImageView.leadingAnchor.constraint(equalTo: like1ImageView.trailingAnchor, constant: -likeImageViewBetweenConstant),
            like2ImageView.heightAnchor.constraint(equalToConstant: likeImageViewLabelHeight),
            like2ImageView.widthAnchor.constraint(equalToConstant: likeImageViewWidth),
            
            like3ImageView.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
            like3ImageView.leadingAnchor.constraint(equalTo: like2ImageView.trailingAnchor, constant: -likeImageViewBetweenConstant),
            like3ImageView.heightAnchor.constraint(equalToConstant: likeImageViewLabelHeight),
            like3ImageView.widthAnchor.constraint(equalToConstant: likeImageViewWidth)
        ])
    }
    
    private func setLikeLabelConstraint() {
        NSLayoutConstraint.activate([
            likeLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
            likeLabel.leadingAnchor.constraint(equalTo: like3ImageView.trailingAnchor, constant: likeLabelLeadingConstant),
            likeLabel.heightAnchor.constraint(equalToConstant: likeImageViewLabelHeight)
        ])
    }
    
    private func setPostTextViewConstraint() {
        NSLayoutConstraint.activate([
            postTextView.topAnchor.constraint(equalTo: like1ImageView.bottomAnchor, constant: postTextViewTopConstant),
            postTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postTextView.heightAnchor.constraint(equalToConstant: postTextViewHeight)
        ])
    }

    // MARK: - Action
    @objc private func likeButtonTapped(){
        print("like 클릭")
        delegate?.likeButtonTapped()
    }
    @objc private func commentButtonTapped(){
        print("comment 클릭")
        delegate?.commentButtonTapped()
    }
    
    // MARK: - Helper
    // 이미지를 조절하고 싶었으나, SF Symbol이 각각 크기가 달라서 힘듬.
    private func resizeUIImage(imageName: String, heightSize: Double) -> UIImage {
        let image = UIImage(systemName: imageName)
        // 원하는 높이를 설정
        let targetHeight: CGFloat = heightSize
        
        // 원래 이미지의 비율을 유지하면서 이미지 리사이즈
        let originalAspectRatio = image!.size.width / image!.size.height
        let targetWidth = targetHeight * originalAspectRatio
        
        // 목표 크기 설정
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        // SF Symbol Configuration을 생성하고 weight를 변경
        let configuration = UIImage.SymbolConfiguration(weight: .regular)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image?.withConfiguration(configuration).draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    // FeedView의 크기를 계산하기 위해
    func calFeedViewHeight() -> Double {
        var viewHeight: Double = 0
        
        let heights: [Double] = [profileHeight, imageCollectionTopConstant, imageCollectionViewHeight, buttonFrame, likeImageViewLabelHeight, postTextViewTopConstant, postTextViewHeight]
        
        heights.forEach{
            viewHeight += $0
        }
        
        return viewHeight
    }
}


