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
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = ThemeColor.deepPink
        return pageControl
    }()
    
    let menuCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Collection.menuSpacing
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
        view.backgroundColor = ThemeColor.borderLineColor
        return view
    }()
    
    let recommendedStore: ReuseCollectionView = {
        let storeCollection = ReuseCollectionView()
        storeCollection.translatesAutoresizingMaskIntoConstraints = false
        storeCollection.titleLabel.text = "추천 스토어"
        return storeCollection
    }()
    
    let secondBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor.borderLineColor
        return view
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
        print("메뉴사이즈",Collection.menuSize)
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
        contentView.addSubview(menuCollectionView)
        contentView.addSubview(borderView)
        contentView.addSubview(recommendedStore)
        contentView.addSubview(secondBorderView)
        contentView.addSubview(recommendedPlace)
        print("asdf",UIScreen.main.bounds.width)
        NSLayoutConstraint.activate([
            rankCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            // rankCollectionView 배너와 같이 뷰의 크기와 셀의 크기를 맞추는 경우
            // 뷰의 크기를 화면 크기와 맞추는 경우
            // 소수점이 들어가는 경우
            // rankCollectionView와 cell크기를 동일하게 맞추었지만 cell의 높이에 0.16666666 차이발생
            // 정수화시켜서 크기를 맞추어서 해결 (모든 constraints에 해당하는 사항은 아님)
            rankCollectionView.widthAnchor.constraint(equalToConstant: CGFloat(Collection.bannerWidth)),
            rankCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(Collection.bannerHeight)),
            
            pageControl.bottomAnchor.constraint(equalTo: rankCollectionView.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
                    
            menuCollectionView.topAnchor.constraint(equalTo: rankCollectionView.bottomAnchor, constant: 20),
            menuCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            menuCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(Collection.cellHeightSize)),
            
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor, constant: 20),
            borderView.heightAnchor.constraint(equalToConstant: 10),
            
            recommendedPlace.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 30),
            recommendedPlace.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendedPlace.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendedPlace.reuseCollection.heightAnchor.constraint(equalToConstant: Collection.reusePlaceHeightSize),
            
            secondBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            secondBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            secondBorderView.topAnchor.constraint(equalTo: recommendedPlace.bottomAnchor, constant: 15),
            secondBorderView.heightAnchor.constraint(equalToConstant: 1),
            
            recommendedStore.topAnchor.constraint(equalTo: secondBorderView.bottomAnchor, constant: 15),
            recommendedStore.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommendedStore.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendedStore.reuseCollection.heightAnchor.constraint(equalToConstant: CGFloat(Collection.reuseStoreHeightSize)),
            recommendedStore.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -150),
            

            ])
    }
}
