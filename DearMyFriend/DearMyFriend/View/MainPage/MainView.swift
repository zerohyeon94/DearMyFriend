import UIKit

class MainView: UIView {

    let logoImgae: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rankeView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "three")
        view.contentMode = .scaleToFill
        return view
    }()
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: Collection.itemSize, height: Collection.itemSize)
        flowLayout.minimumLineSpacing = Collection.spacingWitdh
        flowLayout.minimumInteritemSpacing = Collection.spacingWitdh

        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let recommendationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoLayout()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupContentView() {
        contentView.addSubview(rankeView)
        contentView.addSubview(collectionView)
        contentView.addSubview(recommendationView)
        
        NSLayoutConstraint.activate([
            rankeView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            rankeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rankeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rankeView.heightAnchor.constraint(equalToConstant: 200),
                    
            collectionView.topAnchor.constraint(equalTo: rankeView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: Collection.itemSize*2 + Collection.spacingWitdh),
                    
            recommendationView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            recommendationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            recommendationView.heightAnchor.constraint(equalToConstant: 500),
            ])
    }
}
