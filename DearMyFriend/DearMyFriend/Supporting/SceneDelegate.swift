import UIKit
import Firebase
import FirebaseAuth

// SceneDelegate는 iOS 앱에서 여러 화면 또는 Scene 간 전환을 관리하는 역할
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // 앱의 사용자 인터페이스
    var window: UIWindow?
    // 앱을 초기화하고 실행시키는 단계
    // 앱의 기본 화면 및 초기 화면에 어떤 ViewController를 할당할지를 결정하고 설정
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(with: scene)
        checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    public func checkAuthentication() {
        if Auth.auth().currentUser?.isEmailVerified == true {
            StorageService.shared.uploadBanner { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.goToController(with: TabBarController(), navi: false)
                } else {
                    self.goToController(with: TabBarController(), navi: false)
                }
            }
        } else {
            self.goToController(with: LoginController(), navi: true)
        }
    }
    
    private func goToController(with viewController: UIViewController, navi: Bool) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
                
            } completion: { [weak self] _ in
                if navi {
                    let nav = UINavigationController(rootViewController: viewController)
                    nav.modalPresentationStyle = .fullScreen
                    self?.window?.rootViewController = nav
                } else {
                    viewController.modalPresentationStyle = .fullScreen
                    self?.window?.rootViewController = viewController
                }
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }
    
    // 이메일 인증링크를 누르더라도 최종적으로 변경되는 시점은 인증 후 로그인을 해야 바뀐다.
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        guard let mailType = extractType(userActivity) else { return }
        
        if let oobCode = self.extractKey(userActivity) {
            switch mailType {
            case "verifyEmail":
                self.authenticationOfEmail(oobCode) { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        print(error.localizedDescription)
                        // error alert add
                    } else {
                        if let currentViewController = self.window?.rootViewController {
                            AlertManager.certificationCompleteAlert(on: currentViewController)
                        }
                    }
                }
            case "resetPassword":
                let resetController = ResetPasswordController()
                resetController.resetCode = oobCode
                self.goToController(with: resetController, navi: true)
            default:
                return
            }
            
        }
    }
    
    private func extractType(_ userActivity: NSUserActivity) -> String? {
        guard let certificateUrl = userActivity.webpageURL else { return nil }
        let urlString = certificateUrl.absoluteString
        guard let queryOfUrl = URLComponents(string: urlString)?.queryItems?.filter({ $0.name == "mode" }).first else { return nil }
        guard let mailType = queryOfUrl.value else { return nil }
        return mailType
    }
    
    
    private func extractKey(_ userActivity: NSUserActivity) -> String? {
        guard let certificateUrl = userActivity.webpageURL else { return nil }
        let urlString = certificateUrl.absoluteString
        guard let queryOfUrl = URLComponents(string: urlString)?.queryItems?.filter({ $0.name == "oobCode" }).first else { return nil }
        guard let oobCode = queryOfUrl.value else { return nil }
        return oobCode
    }
    
    //guard let queryOfUrl = URLComponents(string: urlString)?.queryItems else { return nil }
    
    private func authenticationOfEmail(_ oobCode: String, completion: @escaping (Error?)->Void) {
        print("이메일 인증")
        Auth.auth().applyActionCode(oobCode) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}

