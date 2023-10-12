import UIKit

class MainCollectionView: UIView {
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let itemSize = (UIScreen.main.bounds.width - Collection.spacingWitdh * (Collection.cellColumns - 1)) / Collection.cellColumns
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.minimumLineSpacing = Collection.spacingWitdh
        flowLayout.minimumInteritemSpacing = Collection.spacingWitdh

        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
