import UIKit

class TabBarController: UITabBarController {
    
    var login:Bool = true
    var completionStatus:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !login {
            let vc = LoginViewController()
            vc.mainViewController = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
        // !login과 !completionStatus가 모두 true이다 보니 두개의 뷰를 present시도발생(오류코드 발생) 그래서 login이 true인 경우에는 하위 조건문 실행
        if login && !completionStatus {
            let vc = UserInfoViewController()
            vc.mainViewController = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func setupTabBar() {
        
        let feedViewController = UINavigationController(rootViewController: FeedViewController())
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        let profileViewController = UINavigationController(rootViewController: MyViewController())
        
        let tabBarItem = UITabBarItem(title: "피드", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        
        let font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 10) ?? UIFont.boldSystemFont(ofSize: 10)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        
        
        feedViewController.tabBarItem = self.setupTabBarAttributes("피드", "list.bullet")

        mainViewController.tabBarItem = self.setupTabBarAttributes("메인", "heart.fill")
        
        profileViewController.tabBarItem = self.setupTabBarAttributes("프로필", "pawprint.fill")
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.9, x: 0, y: 0, blur: 12)

        viewControllers = [feedViewController, mainViewController, profileViewController]
        selectedIndex = 1
    }
    
    func setupTabBarAttributes(_ title: String, _ defaultImageName: String) -> UITabBarItem {
        let font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 10) ?? UIFont.boldSystemFont(ofSize: 5)
        let tabBarColor = ThemeColor.deepPink
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: tabBarColor]
        
        let image = UIImage(systemName: defaultImageName)
        
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: image?.withTintColor(tabBarColor, renderingMode: .alwaysOriginal))
    
        tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        
        return tabBarItem
    }
}
