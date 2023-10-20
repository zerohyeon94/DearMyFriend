import UIKit

class MainViewController: UIViewController {

    // view = testView와 같이 자체를 할당하니 적용되지 않음
    let mainView: MainView = {
        let view = MainView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let MenuViewControllers = [YouTubeViewController(), MapViewController(), WishViewController(), CalculatorViewController()]
    
    let MenuIcons = ButtonIcon.allButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        autoLayout()
        setupCollectionView()
        setupNavi()
    }
    
    func autoLayout() {
        self.view.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupNavi() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = mainView.logoImgae
    }
    
    func setupCollectionView() {
        mainView.collectionView.tag = 0
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        mainView.collectionView.register(MainMenuCellView.self, forCellWithReuseIdentifier: Collection.menuIdentifier)
        
        mainView.rankCollectionView.tag = 1
        mainView.rankCollectionView.dataSource = self
        mainView.rankCollectionView.delegate = self
        mainView.rankCollectionView.register(RankImageCellView.self, forCellWithReuseIdentifier: Collection.rankIdentifier)
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return MenuViewControllers.count
        case 1:
            mainView.pageControl.numberOfPages = 5
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.menuIdentifier, for: indexPath) as! MainMenuCellView
            cell.iconSet = MenuTest.allMenu[indexPath.item]
            return cell
        case 1:
            print("test")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.rankIdentifier, for: indexPath) as! RankImageCellView
            cell.myImageView.image = Rankbanner.image[indexPath.item]
            return cell
        default:
            return UICollectionViewCell()
        }
       
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(MenuViewControllers[indexPath.row], animated: false)
        case 1:
            return
        default:
            return
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt                            indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        return CGSize(width: Collection.itemSize, height: Collection.itemSize)

    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // page control 설정.
        if scrollView.frame.size.width != 0 {
            let value = (scrollView.contentOffset.x / scrollView.frame.width)
            mainView.pageControl.currentPage = Int(round(value))
        }
    }
}
