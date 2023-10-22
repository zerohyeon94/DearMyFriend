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
        
        feedViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        mainViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart.fill"), selectedImage: UIImage(systemName: "heart.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "pawprint.fill"), selectedImage: UIImage(systemName: "pawprint.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal))
        
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.9, x: 0, y: 0, blur: 12)

        viewControllers = [feedViewController, mainViewController, profileViewController]
        selectedIndex = 1
    }
}
