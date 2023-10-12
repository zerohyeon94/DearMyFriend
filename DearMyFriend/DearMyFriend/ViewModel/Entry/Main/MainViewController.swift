import UIKit

class MainViewController: UIViewController {
    
    let menuView: MainCollectionView = {
        let view = MainCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let MenuViewControllers = [YouTubeViewController(), MapViewController(), WishViewController(), StoreViewController(), CalculatorViewController()]
    
    let MenuImages = ["play.rectangle", "map.fill", "heart.fill", "carrot.fill", "fork.knife"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        autoLayout()
    }
    
    func autoLayout() {
        self.view.addSubview(menuView)
        NSLayoutConstraint.activate([
            menuView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            menuView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            menuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            menuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            menuView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setupCollectionView() {
        menuView.collectionView.dataSource = self
        menuView.collectionView.delegate = self
        menuView.collectionView.register(MainMenuCellView.self, forCellWithReuseIdentifier: Collection.identifiet)
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MenuViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Collection.identifiet, for: indexPath) as! MainMenuCellView
        cell.imageUrl = MenuImages[indexPath.row]
        return cell
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MenuViewControllers[indexPath.row], animated: true)
    }
}
