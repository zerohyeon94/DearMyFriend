import Foundation
import UIKit

class MyPostView: UIView {
    // MARK: - Properties
    let collectionViewDummyData: [String] = ["spider1", "spider2", "spider3", "one", "two", "three"]
    
    // MARK: Collection View
    private lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: Initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure & Constant
    func setupCollectionView() {
        postCollectionView.register(MyPostCollectionViewCell.self, forCellWithReuseIdentifier: MyPostCollectionViewCell.identifier)

        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        
        setCollectionViewConstraints()
    }
    
    func setCollectionViewConstraints() {
        addSubview(postCollectionView)
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postCollectionView.topAnchor.constraint(equalTo: topAnchor),
            postCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func reloadCollectionView() {
        print("reloadCollectionView")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        
        postCollectionView.reloadData()
    }
}

extension MyPostView: UICollectionViewDataSource {
    // collection view의 item 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let userFeedData = MyViewController.myFeedData
        print("userFeedData.count: \(userFeedData.count)")
        return userFeedData.count
    }
    
    // Collection View의 cell 표시 방법
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPostCollectionViewCell.identifier, for: indexPath) as? MyPostCollectionViewCell else { return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        
        let userFeedData = MyViewController.myFeedData[indexPath.row]

        print("image: \(userFeedData.values.first?.image.first)")
        
        cell.setPostImageView(with: userFeedData.values.first?.image.first ?? "image upload fail")
        return cell
    }
}

extension MyPostView: UICollectionViewDelegateFlowLayout {
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2) / 3
        
        let size = CGSize(width: width, height: width)
        return size
    }
}
