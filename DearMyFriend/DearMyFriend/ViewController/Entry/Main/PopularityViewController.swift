import UIKit

class PopularityViewController: UIViewController {
    
    var mainPage: MainViewController?
    var bannerTime = Timer()
    var pageOfNumber = 0
    private var initialY: CGFloat = 0.0
    private var translationY: CGFloat = 0.0
    // 프로필 이미지
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rankCollectionView)
        view.backgroundColor = .black
        autoLayout()
        setupCollectionView()
        setupTimer()
    }
    
    func autoLayout() {
        NSLayoutConstraint.activate([
            rankCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            rankCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            rankCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            rankCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func setupCollectionView() {
        self.rankCollectionView.dataSource = self
        self.rankCollectionView.delegate = self
        self.rankCollectionView.register(PopularityCellView.self, forCellWithReuseIdentifier: Collection.rankStoryIdentifier)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(panGesture) // 이 줄 주석 해제
    }
    
    func indicatorControl(_ indicator: IndicatorCircle, _ touchBool: Bool) {
        if touchBool {
            guard let presentation = indicator.indicatorLayer.presentation() else { return }
            indicator.indicatorLayer.strokeEnd = presentation.strokeEnd
            indicator.indicatorLayer.removeAllAnimations()
            
            let duration = CGFloat(IndicatorInfo.duration)
            indicator.remainingTime = duration - (presentation.strokeEnd * duration)
            
            indicator.startPoint = presentation.strokeEnd
        } else {
            indicator.animateForegroundLayer()
        }
    }
    
    func setupTimer() {
        bannerTime = Timer.scheduledTimer(timeInterval: IndicatorInfo.duration , target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func timerCounter() {
        
        if pageOfNumber < 4 {
            pageOfNumber += 1
            rankCollectionView.scrollToItem(at: [0, pageOfNumber], at: .left, animated: true)
        } else {
            self.bannerTime.invalidate()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let maxYTranslation: CGFloat = 100 // 최대 이동 거리
        
        switch gesture.state {
        case .began:
            initialY = rankCollectionView.frame.origin.y
        case .changed:
            if translation.y > 0 && translation.y <= maxYTranslation {
                // 뷰를 아래로 이동
                translationY = translation.y
                rankCollectionView.frame.origin.y = initialY + translationY
            }
        case .ended:
            print(translationY)
            print(maxYTranslation)
            if translationY > maxYTranslation*0.6 {
                // 최소 거리 이상으로 드래그하면 모달을 닫음
                self.mainPage?.setupTimer()
                self.dismiss(animated: true, completion: nil)
                self.bannerTime.invalidate()
            } else {
                // 최소 거리에 도달하지 않았을 때 초기 위치로 되돌리기
                UIView.animate(withDuration: 0.3) {
                    self.rankCollectionView.frame.origin.y = self.initialY
                }
            }
        default:
            break
        }
    }
}

extension PopularityViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Rankbanner.image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.rankStoryIdentifier, for: indexPath) as! PopularityCellView
        cell.toucheOfImage = { [weak self] (senderCell) in
            self?.indicatorControl(senderCell.indicatorCircle, senderCell.touchBool)
        }
        cell.petPhoto.image = Rankbanner.image[indexPath.item]
        cell.indicatorCircle.resetTime()
        cell.indicatorCircle.animateForegroundLayer()
        return cell
    }
    
    
}

extension PopularityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.bannerTime.invalidate()
        self.setupTimer()
        if let popularityCell = cell as? PopularityCellView {
            popularityCell.indicatorCircle.resetTime()
        }
    }
}

extension PopularityViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt                            indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
}

extension PopularityViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        let intPage = Int(page)
        if pageOfNumber != intPage {
            pageOfNumber = intPage
        }
    }
}
