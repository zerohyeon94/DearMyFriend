import UIKit

class MainViewController: UIViewController {
    
    var pageOfNumber = 1
    var bannerTime = Timer()
    
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
        setupBanner()
        autoLayout()
        setupCollectionView()
        setupNavi()
        setupTimer()
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
    
    func setupBanner() {
        Rankbanner.image.insert(Rankbanner.image[Rankbanner.image.count-1], at: 0)
        Rankbanner.image.append(Rankbanner.image[1])
    }
    
    override func viewDidLayoutSubviews() {
        mainView.rankCollectionView.scrollToItem(at: [0, 1], at: .left, animated: false)
    }
    
    func setupTimer() {
        bannerTime = Timer.scheduledTimer(timeInterval: 3 , target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func timerCounter() {
        if pageOfNumber < 5 {
            pageOfNumber += 1
            mainView.rankCollectionView.scrollToItem(at: [0, pageOfNumber], at: .left, animated: true)
        } else {
            pageOfNumber = 1
            mainView.rankCollectionView.scrollToItem(at: [0, pageOfNumber], at: .left, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return MenuViewControllers.count
        case 1:
            mainView.pageControl.numberOfPages = Rankbanner.image.count-2
            return Rankbanner.image.count
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
    
    /*
     무한스크롤을 위해서 첫번째와 마지막 데이터를 추가해놓은 상황
     [1,2,3] 이라면 [3,1,2,3,1] 과 같이 추가해놓고 첫 시작점을 첫번째 1번으로 했음
     로드되면  scrollview.contentOffset.x의 위치는 scrollView.frame.width와 같음 (0 아님)
     
     무한스크롤
     [1,2,3] 이라면 [3,1,2,3,1] 과 같이 추가해놓고 첫 시작점을 첫번째 1번으로 했음
     scrollview.contentOffset.x (현재의 위치)가 첫번째 페이지라면 마지막 페이지 전으로 이동 (1번과 4번은 같음)
     scrollview.contentOffset.x (현재의 위치)가 마지막 페이지라면 첫번째 페이지 다음으로 이동 (0번과 3번은 같음)
     
     페이지컨트롤
     * page indicator의 계산식 : scrollview.contentOffset.x (현재의 위치) / scrollView.frame.width (스크롤뷰의 사이즈 : contentSize X)
     * 발생하는 문제: pageControl이 첫번째 1의 위치를 2번째로 인지하고 page indicator가 2번째에 표시되어 있음
     * 해결하는 방법
        1. 첫 시작점의 위치가 0이어야 하나 무한스크롤을 위해서 3을 추가해두었기 때문에 scrollView.contentOffset.x = scrollview.frame.width와 같음
        2. scrollView.contentOffset.x에서 scrollView.frame.width를 뺀 값을 기본값으로 잡아주면 처음 값이 0이 됨
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageCoordinate = scrollView.contentOffset.x - scrollView.frame.width
        
        if scrollView.frame.size.width != 0 {
            let value = (pageCoordinate / scrollView.frame.width)
            mainView.pageControl.currentPage = Int(round(value))
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let last = Rankbanner.image.count-2
        if scrollView.contentOffset.x == 0  {
            mainView.rankCollectionView.scrollToItem(at: [0, last], at: .left, animated: false)
        }
        if scrollView.contentOffset.x == scrollView.frame.width * (Rankbanner.imageNum-1)  {
            mainView.rankCollectionView.scrollToItem(at: [0, 1], at: .left, animated: false)
        }
        
        let page = scrollView.contentOffset.x / scrollView.frame.width
        let intPage = Int(page)
        pageOfNumber = intPage
    }
}
