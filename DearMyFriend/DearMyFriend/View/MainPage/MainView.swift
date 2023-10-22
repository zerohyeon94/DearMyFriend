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
        view.showsVerticalScrollIndicator = true
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
    
    let rankCollectionView : UICollectionView = {

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
    
    let pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.backgroundColor = .systemMint
        return pageControl
    }()
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = Collection.spacingWidth
        flowLayout.minimumInteritemSpacing = Collection.spacingWidth

        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemBlue
        return collection
    }()
    
    let recommendationView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
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
        contentView.addSubview(rankCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(collectionView)
        contentView.addSubview(recommendationView)
        
        NSLayoutConstraint.activate([
            rankCollectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            rankCollectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            rankCollectionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            rankCollectionView.heightAnchor.constraint(equalToConstant: 250),
            
            pageControl.topAnchor.constraint(equalTo: rankCollectionView.bottomAnchor, constant: 10),
            pageControl.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
                    
            collectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: Collection.itemSize),
                    
            recommendationView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            recommendationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            recommendationView.heightAnchor.constraint(equalToConstant: 1500),
            ])
    }
}
