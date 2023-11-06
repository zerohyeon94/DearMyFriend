// FeedViewController
// Feed View
// Feed 화면에서 게시글을 보여주는 View
// 해당 View는 FeedViewController에서 TableView에 들어가는 Cell에 들어갈 View 이다.

import Foundation
import UIKit

protocol FeedViewDelegate: AnyObject {
    func likeButtonTapped()
    func commentButtonTapped(index: Int)
}

class FeedView: UIView {
    // MARK: Properties
    var delegate: FeedViewDelegate?
    var tableViewCellindex: Int = 0
    // ImageView
    let profileImageFrame: CGFloat = 40
    let borderLineColor: CGColor = ThemeColor.borderLineColor.cgColor
    // Label
    let userNicknameLabelSize: CGFloat = 18
    // Image CollectionView & Page Control
    let imageNames: [String] = ["spider1", "spider2", "spider3"]
    // Like & Comment Button
    var isLikeButtonSelected = false
    let buttonFrame: CGFloat = 50
    let buttonSize: CGFloat = 30
    let topBottomButtonPadding: CGFloat = 8
    let leftRightButtonPadding: CGFloat = 0
    let likeButtonImage: String = "heart"
    let likeFillButtonImage: String = "heart.fill"
    let buttonColor: UIColor = ThemeColor.deepPink
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
        imageView.layer.borderColor = borderLineColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var userNicknameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: userNicknameLabelSize)
        //        label.font = UIFont.systemFont(ofSize: userNicknameLabelSize)
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
        pageControl.currentPageIndicatorTintColor = ThemeColor.deepPink
        pageControl.pageIndicatorTintColor = ThemeColor.pink
        
        return pageControl
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: buttonFrame, height: buttonFrame) // image Button 크기 지정.
        
        let resizedLikeImage = resizeUIImage(imageName: likeButtonImage, heightSize: buttonSize, tintColor: buttonColor)
        button.setImage(resizedLikeImage, for: .normal)
        let resizedLikeFillImage = resizeUIImage(imageName: likeFillButtonImage, heightSize: buttonSize, tintColor: buttonColor)
        button.setImage(resizedLikeFillImage, for: .selected)
        
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        // 패딩 설정
        let padding = UIEdgeInsets(top: topBottomButtonPadding, left: leftRightButtonPadding, bottom: topBottomButtonPadding, right: leftRightButtonPadding)
        button.contentEdgeInsets = padding
        
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: buttonFrame, height: buttonFrame)
        
        let resizedImage = resizeUIImage(imageName: commentButtonImage, heightSize: buttonSize, tintColor: buttonColor)
        button.setImage(resizedImage, for: .normal)
        //        button.setImage(UIImage(systemName: commentButtonImage), for: .normal)
        //        button.tintColor = buttonColor
        
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        
        // 패딩 설정
        let padding = UIEdgeInsets(top: topBottomButtonPadding, left: leftRightButtonPadding, bottom: topBottomButtonPadding, right: leftRightButtonPadding)
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
        imageView.layer.borderColor = borderLineColor
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
        imageView.layer.borderColor = borderLineColor
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
        imageView.layer.borderColor = borderLineColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var likeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: likelabelSize)
        //        label.font = UIFont.systemFont(ofSize: likelabelSize, weight: .medium)
        label.text = "조영현님 외 5명이 좋아합니다." // 추후 파이어베이스로 받아온 사용자의 닉네임 표시
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var postTextView: UITextView = {
        let textView = UITextView()
        
        textView.isEditable = false
        textView.isSelectable = true // TextView 내의 Text를 선택하고 복사 여부.
        textView.isScrollEnabled = false // 스크롤 비활성화
        
        textView.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: textViewFont)
        //        textView.font = UIFont.systemFont(ofSize: textViewFont)
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
    let imageCollectionSideSpaceConstant: CGFloat = 20
    let imageCollectionViewHeight: CGFloat = 300
    let pageControlHeight: CGFloat = 30
    // Like & Comment Button
    let likeLeadingConstant: CGFloat = 0
    let buttonHeight: CGFloat = 50
    let buttonWidth: CGFloat = 42
    // like ImageView & Label
    let likeImageViewLeadingConstant: CGFloat = 6
    let likeImageViewBetweenConstant: CGFloat = 4
    let likeImageViewLabelHeight: CGFloat = 20
    let likeImageViewWidth: CGFloat = 20
    let likeLabelLeadingConstant: CGFloat = 4
    // post TextView
    let postTextViewTopConstant: CGFloat = 8
    let postTextViewHeight: CGFloat = 50
    
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
            likeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            likeButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        ])
    }
    
    private func setCommentButtonConstraint() {
        NSLayoutConstraint.activate([
            commentButton.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor),
            commentButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            commentButton.widthAnchor.constraint(equalToConstant: buttonWidth)
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
        isLikeButtonSelected.toggle()
        likeButton.isSelected = isLikeButtonSelected
        
        let resizedImage = resizeUIImage(imageName: isLikeButtonSelected ? likeFillButtonImage : likeButtonImage, heightSize: buttonSize, tintColor: buttonColor)
        likeButton.setImage(resizedImage, for: .selected)
        
        // index값을 얻어왔으니까, Feed 정보 중 몇번째인지 확인.
        print("cell Index : \(tableViewCellindex)")
        
        // 현재 Feed에 가져온 정보 확인.
        var feedCellIndex: Int = tableViewCellindex
        var feedDataKey: String // 업로드된 시간 -> Feed 내 Document ID
        if let firstKey = FeedViewController.feedDatas[tableViewCellindex].keys.first {
            feedDataKey = firstKey
        } else {
            // 값이 없는 경우에 대한 처리
            feedDataKey = "" // 또는 다른 기본값
        }
        var feedDataValue: FeedData // 위의 Document ID 내 필드값.
        if let feedData = FeedViewController.feedDatas[tableViewCellindex].values.first {
            feedDataValue = feedData
        } else {
            // 값이 없는 경우에 대한 처리
            feedDataValue = FeedData(id: "", image: [""], post: "", like: [""], comment: [[:]])
        }
        
        // TEST: 현재 로그인 되어있는 ID userDefault로 가져오기 임시로 아이디 사용.
        var id: String = "_zerohyeon"
        
        print("feedData 상태 업데이트 전 : \(feedDataValue)")
        
        if feedDataValue.like.contains(id) {
            if let index = feedDataValue.like.firstIndex(of: id) {
                print("index: \(index)")
                feedDataValue.like.remove(at: index)
            }
        } else {
            feedDataValue.like.append(id)
        }
        
        print("feedData 상태 업데이트 후 : \(feedDataValue)")
        
        MyFirestore().updateFeedLikeData(documentID: feedDataKey, updateFeedData: feedDataValue)
        
        delegate?.likeButtonTapped()
    }
    
    @objc private func commentButtonTapped(){
        print("comment 클릭")
        
        print("cell Index : \(tableViewCellindex)")
        
        delegate?.commentButtonTapped(index: tableViewCellindex)
    }
    
    // MARK: - Helper
    // 이미지를 조절하고 싶었으나, SF Symbol이 각각 크기가 달라서 힘듬.
    //    func resizeUIImage(imageName: String, heightSize: Double, tintColor: UIColor) -> UIImage {
    //        let image = UIImage(systemName: imageName)
    //        // 원하는 높이를 설정
    //        let targetHeight: CGFloat = heightSize
    //
    //        // 원래 이미지의 비율을 유지하면서 이미지 리사이즈
    //        let originalAspectRatio = image!.size.width / image!.size.height
    //        let targetWidth = targetHeight * originalAspectRatio
    //
    //        // 목표 크기 설정
    //        let targetSize = CGSize(width: targetWidth, height: targetHeight)
    //
    //        // SF Symbol Configuration을 생성하고 weight를 변경
    //        let configuration = UIImage.SymbolConfiguration(weight: .regular)
    //
    //        // 이미지를 다시 그리면서 색상 변경.
    //        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
    //        tintColor.set() // 색상 설정
    //        image?.withConfiguration(configuration).draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
    //        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return resizedImage!
    //    }
    
    func resizeUIImage(imageName: String, heightSize: Double, tintColor: UIColor) -> UIImage {
        let image = UIImage(systemName: imageName)
        // 원하는 높이를 설정
        let targetHeight: CGFloat = CGFloat(heightSize)
        
        // 원래 이미지의 비율을 유지하면서 이미지 리사이즈
        let originalAspectRatio = image!.size.width / image!.size.height
        let targetWidth = targetHeight * originalAspectRatio
        
        // 목표 크기 설정
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        // 이미지를 색상 변경.
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        
        // 이미지를 그리고 색상 적용
        tintColor.set()
        
        tintedImage?.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        
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
        
        print("viewHeight: \(viewHeight)")
        return viewHeight
    }
}
