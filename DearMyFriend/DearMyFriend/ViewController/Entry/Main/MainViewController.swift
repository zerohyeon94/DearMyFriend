import UIKit

class MainViewController: UIViewController {

    // view = testView와 같이 자체를 할당하니 적용되지 않음
    let testView: MainView = {
        let view = MainView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let MenuViewControllers = [YouTubeViewController(), MapViewController(), WishViewController(), CalculatorViewController()]
    
    let MenuIcons = ButtonIcon.allButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        autoLayout()
        setupNavi()
    }
    
    func setupNavi() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.titleView = testView.logoImgae
    }
    
    func autoLayout() {
        self.view.addSubview(testView)
        
        NSLayoutConstraint.activate([
            testView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            testView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            testView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setupCollectionView() {
        testView.collectionView.dataSource = self
        testView.collectionView.delegate = self
        testView.collectionView.register(MainMenuCellView.self, forCellWithReuseIdentifier: Collection.identifiet)
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MenuViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.identifiet, for: indexPath) as! MainMenuCellView
        cell.iconSet = MenuTest.allMenu[indexPath.item]
        return cell
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(MenuViewControllers[indexPath.row], animated: false)
    }
}
