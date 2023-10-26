import UIKit

class MainView: UIView {
    
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
    
    let logoImgae: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
        pageControl.pageIndicatorTintColor = UIColor.systemGray
        pageControl.currentPageIndicatorTintColor = UIColor.systemRed
        return pageControl
    }()
    
    let menuCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "dee2e6", alpha: 1)
        return view
    }()
    
    let recommendedStore: ReuseCollectionView = {
        let storeCollection = ReuseCollectionView()
        storeCollection.translatesAutoresizingMaskIntoConstraints = false
        storeCollection.titleLabel.text = "추천 스토어"
        return storeCollection
    }()
    
    let recommendedPlace: ReuseCollectionView = {
        let storeCollection = ReuseCollectionView()
        storeCollection.translatesAutoresizingMaskIntoConstraints = false
        storeCollection.titleLabel.text = "추천 플레이스"
        return storeCollection
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
        contentView.addSubview(logoImgae)
        contentView.addSubview(rankCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(menuCollectionView)
        contentView.addSubview(borderView)
        contentView.addSubview(recommendedStore)
        contentView.addSubview(recommendedPlace)
        print("asdf",UIScreen.main.bounds.width)
        NSLayoutConstraint.activate([
            logoImgae.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImgae.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            logoImgae.widthAnchor.constraint(equalToConstant: 30),
            logoImgae.heightAnchor.constraint(equalToConstant: 30),
            
            rankCollectionView.topAnchor.constraint(equalTo: logoImgae.bottomAnchor, constant: 5),
            // rankCollectionView 배너와 같이 뷰의 크기와 셀의 크기를 맞추는 경우
            // 뷰의 크기를 화면 크기와 맞추는 경우
            // 소수점이 들어가는 경우
            // rankCollectionView와 cell크기를 동일하게 맞추었지만 cell의 높이에 0.16666666 차이발생
            // 정수화시켜서 크기를 맞추어서 해결 (모든 constraints에 해당하는 사항은 아님)
            rankCollectionView.widthAnchor.constraint(equalToConstant: CGFloat(Collection.bannerWidth)),
            rankCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(Collection.bannerHeight)),
            
            pageControl.topAnchor.constraint(equalTo: rankCollectionView.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
                    
            menuCollectionView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            menuCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            menuCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            menuCollectionView.heightAnchor.constraint(equalToConstant: Collection.menuSize),
            
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor, constant: 10),
            borderView.heightAnchor.constraint(equalToConstant: 2),
            
            recommendedStore.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 30),
            recommendedStore.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recommendedStore.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recommendedStore.reuseCollection.heightAnchor.constraint(equalToConstant: Collection.reuseStoreHeightSize),
            
            recommendedPlace.topAnchor.constraint(equalTo: recommendedStore.bottomAnchor, constant: 30),
            recommendedPlace.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recommendedPlace.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recommendedPlace.reuseCollection.heightAnchor.constraint(equalToConstant: Collection.reusePlaceHeightSize),
            recommendedPlace.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            ])
    }
}
