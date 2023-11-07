// FeedViewController
// FeedTableViewCell
// Feed 화면에서 TableView에 들어갈 Cell
import Foundation
import UIKit

class FeedTableViewCell: UITableViewCell {
    // MARK: Properties
    static let identifier = "FeedTableViewCell"
    
    var cellIndex: Int = 0
    
    let feedView: FeedView = .init(frame: .zero)
    let sideSpaceConstant: CGFloat = 20
    
    // TableView Cell 내 CollectionView
    var imageNames: [String] = []
    
    private func setupCollectionView() {
        feedView.imageCollectionView.delegate = self
        feedView.imageCollectionView.dataSource = self
    }
    
    let separatorLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = ThemeColor.deepPink
        return view
    }()
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        //        self.contentView.backgroundColor = .yellow
        
        configure()
        
        addSubview(separatorLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let separatorHeight: CGFloat = 1.0 // 원하는 구분선 두께로 설정
        print("frame.size.height: \(frame.size.height)")
        separatorLine.frame = CGRect(x: 0, y: frame.size.height - 10, width: frame.size.width, height: separatorHeight)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageNames = []
    }
    
    // MARK: Configure
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI(){
        self.contentView.addSubview(feedView)
        feedView.translatesAutoresizingMaskIntoConstraints = false
        
        feedView.postTextView.delegate = self
        feedView.tableViewCellindex = cellIndex
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            feedView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sideSpaceConstant),
            feedView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -sideSpaceConstant),
            feedView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    func setFeed(feedData: FeedData, index: Int) {
        feedView.tableViewCellindex = index
        feedView.userNicknameLabel.text = feedData.id
        feedView.postTextView.text = feedData.post
        imageNames = feedData.image
        
        // 좋아요 상태 확인
        var id: String = "_zerohyeon"
        if feedData.like.contains(id) {
            feedView.likeButton.isSelected = true
        } else {
            feedView.likeButton.isSelected = false
        }
        
        // CollectionView를 다시 로드
        feedView.imageCollectionView.reloadData()
        
        setupCollectionView()
    }
}

extension FeedTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // page control 설정.
        if scrollView.frame.size.width != 0 {
            let value = (scrollView.contentOffset.x / scrollView.frame.width)
            feedView.pageControl.currentPage = Int(round(value))
        }
    }
}

extension FeedTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        feedView.pageControl.numberOfPages = imageNames.count
        //        print("imageNames.count: \(imageNames.count)")
        return self.imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        
        //        print("cell에서 확인 imageNames: \(imageNames)")
        cell.configureURL(imageURL: imageNames[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension FeedTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight(for: textView)
    }
    
    func updateTextViewHeight(for textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // 최소 높이 및 최대 높이 설정 (원하는 값으로 변경)
        let minHeight: CGFloat = 50
        let maxHeight: CGFloat = 200
        
        if newSize.height < minHeight {
            textView.frame.size.height = minHeight
        } else if newSize.height > maxHeight {
            textView.isScrollEnabled = true
        } else {
            textView.isScrollEnabled = false
            textView.frame.size.height = newSize.height
        }
    }
}
