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
    let sideSpaceConstant: CGFloat = 16
    
    // TableView Cell 내 CollectionView
    var imageNames: [String] = []
    
    private func setupCollectionView() {
        feedView.imageCollectionView.delegate = self
        feedView.imageCollectionView.dataSource = self
    }
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//        self.contentView.backgroundColor = .yellow
        
        print("설정된 cell index : \(cellIndex)")
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
