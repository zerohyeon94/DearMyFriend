//
//  NewFeedView.swift
//  DearMyFriend
//
//  Created by Macbook on 11/14/23.
//

import UIKit

class NewFeedView: UITableViewCell {
    
    // MARK: - UI components
    public var feed: NewFeedModel? {
        didSet {
            if let feed = feed {
                print("피드 게시글 이미지 수 : \(feed.feedImages.count)")
                self.imageList = feed.feedImages
                self.userName.text = feed.userName
                self.postLabel.text = feed.post
                self.postNameLabel.text = feed.userName
                self.profileView.image = feed.profileImage
                self.documentID = feed.documentID
                self.likePost = feed.likeBool
                self.imageCollection.reloadData()
            }
        }
    }
    
    public var likePost: Bool? {
        didSet {
            guard let likePost = likePost else { return }
            print(likePost)
            if likePost {
                let configuration = UIButton.Configuration.buttonConfigurationWithImage(imageName: "heart.fill")
                self.likeButton.configuration = configuration
                self.likeButton.tintColor = ThemeColor.deepPink
            } else {
                let configuration = UIButton.Configuration.buttonConfigurationWithImage(imageName: "heart")
                self.likeButton.configuration = configuration
                self.likeButton.tintColor = ThemeColor.titleColor
            }
        }
    }
    
    private var documentID: String?
    
    private var imageList: [Int:UIImage] = [:]
    
    public var likeButtonTapped: ((String, Bool) -> Void) = { documentID, likeBool in }
    public var commetButtonTapped: (() -> Void) = { }
    public var reportButtonTapped: ((String) -> Void) = { documentID in }
    
    private let profileView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
    
        //        view.image =   ‼️ 하영이한테 기본 고양이, 강아지 달라고 하기
        return view
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.titleColor
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 15)
        label.text = "Error"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var reportButton: UIButton = {
        let configuration = UIButton.Configuration.buttonConfigurationWithImage(imageName: "ellipsis")
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(reportButtonTapped(_:)), for: .touchUpInside)
        button.tintColor = ThemeColor.titleColor
        return button
    }()
    
    private lazy var topStakView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileView, userName, reportButton])
        sv.spacing = 10
        sv.backgroundColor = .clear
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    private let imageCollection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private lazy var likeButton: UIButton = {
        let configuration = UIButton.Configuration.buttonConfigurationWithImage(imageName: "heart")
        
        let button = UIButton(configuration: configuration)
        button.tintColor = ThemeColor.titleColor
        button.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let configuration = UIButton.Configuration.buttonConfigurationWithImage(imageName: "message")
        
        let button = UIButton(configuration: configuration)
        button.tintColor = ThemeColor.titleColor
        button.addTarget(self, action: #selector(commentButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var middleStakView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [likeButton, commentButton])
        sv.spacing = 10
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    private let postNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.titleColor
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 15)
        label.text = "Error"
        return label
    }()
    
    private let postLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.titleColor
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 15)
        label.text = "Error"
        return label
    }()
    
    
    private lazy var bottomStakView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [postNameLabel, postLabel])
        sv.spacing = 5
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    public let bottomLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.titleColor
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: 15)
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = ThemeColor.textColor
        pageControl.currentPageIndicatorTintColor = ThemeColor.deepPink
        return pageControl
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        autoLayout()
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalSpacing: CGFloat = 20
        
        var contentViewFrame = contentView.frame
        
        contentViewFrame.origin.x += horizontalSpacing
        contentViewFrame.size.width -= horizontalSpacing * 2 // 양쪽으로 동일한 간격적용
        
        contentView.frame = contentViewFrame
    }
    
    override func prepareForReuse() {
        self.profileView.image = nil
        self.bottomLabel.text = nil
    }
    
    // MARK: - UI Setup
    
    private func autoLayout() {
        self.contentView.addSubviews([
            topStakView,
            imageCollection,
            middleStakView,
            bottomStakView,
            bottomLabel,
            pageControl
        ])
        
        NSLayoutConstraint.activate([
            topStakView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            topStakView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topStakView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            topStakView.heightAnchor.constraint(equalToConstant: 40),
            
            profileView.widthAnchor.constraint(equalToConstant: 40),
            reportButton.widthAnchor.constraint(equalToConstant: 20),
            
            imageCollection.topAnchor.constraint(equalTo: self.topStakView.bottomAnchor, constant: 8),
            imageCollection.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            imageCollection.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imageCollection.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2),
            
            middleStakView.topAnchor.constraint(equalTo: self.imageCollection.bottomAnchor, constant: 10),
            middleStakView.widthAnchor.constraint(equalToConstant: 60),
            middleStakView.heightAnchor.constraint(equalToConstant: 30),
            
            pageControl.centerYAnchor.constraint(equalTo: self.middleStakView.centerYAnchor),
            pageControl.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            bottomStakView.topAnchor.constraint(equalTo: self.middleStakView.bottomAnchor),
            bottomStakView.leadingAnchor.constraint(equalTo: self.middleStakView.leadingAnchor, constant: 5),
            bottomStakView.heightAnchor.constraint(equalToConstant: 30),
           
            bottomLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func setupCollection() {
        self.imageCollection.dataSource = self
        self.imageCollection.delegate = self
        
        self.imageCollection.register(FeedImageCell.self, forCellWithReuseIdentifier: "feedImage")
    }
    // MARK: - Selectors
    
    @objc
    private func likeButtonTapped(_ sender: UIButton) {
        guard let documentID = self.documentID, let likePost = likePost else { return }
        likeButtonTapped(documentID, likePost)
    }
    
    @objc
    private func commentButtonTapped(_ sender: UIButton) {
        commetButtonTapped()
    }
    
    @objc
    private func reportButtonTapped(_ sender: UIButton) {
        guard let documentID = self.documentID else { return }
        reportButtonTapped(documentID)
    }

}

extension NewFeedView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let feedCount = feed?.image?.count else { return 0 }
        self.pageControl.numberOfPages = feedCount
        return feedCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedImage", for: indexPath) as! FeedImageCell
        cell.feedImage = self.imageList[indexPath.item]
        return cell
    }
    
}

extension NewFeedView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt                            indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension NewFeedView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == imageCollection {
            let pageCoordinate = scrollView.contentOffset.x
            
            if scrollView.frame.size.width != 0 {
                let value = (pageCoordinate / scrollView.frame.width)
                pageControl.currentPage = Int(round(value))
            }
        }
    }
    
}
