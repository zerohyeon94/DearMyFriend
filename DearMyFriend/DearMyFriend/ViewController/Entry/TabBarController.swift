import UIKit

class TabBarController: UITabBarController {
    
    var login:Bool = false
    var completionStatus:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBar()
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
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = ThemeColor.borderLineColor.cgColor

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
