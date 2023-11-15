import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let settingsOptions = ["이용약관", "개인정보처리방침", "회원탈퇴", "로그아웃"]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Settings"
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = settingsOptions[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == 2 || indexPath.row == 3 {
            cell.textLabel?.textColor = .red
        } else {
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let urlString = "https://far-octagon-170.notion.site/1396d8caf91041a08ba6e505045656af?pvs=4"
            self.showWebViewController(with: urlString)
            
        case 1:
            let urlString = "https://www.notion.so/dcab8c95d6c848288127665f397e09ad?pvs=4"
            self.showWebViewController(with: urlString)
            
        case 2:
            showWithdrawalAlert()
        case 3:
            showLogoutAlert()
        default:
            break
        }
    }
    
    private func showWebViewController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
    private func setupNavi() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func showDetailViewController(title: String) {
        let setVC = SettingsDetailViewController()
        setVC.title = title
        navigationController?.pushViewController(setVC, animated: true)
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            AuthService.shared.signOut { error in
                if let error = error {
                    print("로그아웃 실패", error)
                } else {
                    print("로그아웃 성공")
                    AuthService.shared.changeController(self)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        alert.view.tintColor = .black
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        present(alert, animated: true, completion: nil)
    }
    
    //회원탈퇴
    func showWithdrawalAlert() {
        // 🟡 추가했음
        let alert = UIAlertController(title: "회원탈퇴", message: "정말로 회원탈퇴 하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            let accountManeger = AuthService.shared
            print("확인버튼 누름")
            
            accountManeger.deleteAccount { [weak self] error in
                guard let self = self else { return }
                
                if error != nil {
                    AlertManager.logoutAlert(on: self)
                    return
                }
            
                accountManeger.deleteFeedInStorage { [weak self] error in
                    guard let self = self else { return }
                    print("스토리지 삭제")
                    if error != nil {
                        AlertManager.registerCheckAlert(on: self)
                        return
                    }
                    
                    accountManeger.deleteFeedInStore { [weak self] error in
                        guard let self = self else { return }
                        
                        if error != nil {
                            AlertManager.registerCheckAlert(on: self)
                            print("회원탈퇴 : firestore 정보 삭제 실패")
                            return
                        }
                        accountManeger.deleteStore { [weak self] error in
                            guard let self = self else { return }
                            
                            if error != nil {
                                AlertManager.registerCheckAlert(on: self)
                                print("회원탈퇴 : firestore 정보 삭제 실패")
                                return
                            }
                            
                            accountManeger.deleteStorage { [weak self] error in
                                guard let self = self else { return }
                                
                                if error != nil {
                                    AlertManager.registerCheckAlert(on: self)
                                    print("회원탈퇴 : Storage 정보 삭제 실패")
                                    return
                                }
                                
                                accountManeger.findEmailIndex { [weak self] emailList, error in
                                    guard let self = self else { return }
                                    
                                    if error != nil {
                                        AlertManager.registerCheckAlert(on: self)
                                        print("회원탈퇴 : 이메일 인덱스추출 실패")
                                        return
                                    }
                                    
                                    let emailList = emailList ?? []
                                    
                                    accountManeger.deleteEmail(emailList: emailList) { [weak self] error in
                                        guard let self = self else { return }
                                        
                                        if error != nil {
                                            AlertManager.registerCheckAlert(on: self)
                                            return
                                        }
                                        accountManeger.changeController(self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        alert.view.tintColor = .black
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        present(alert, animated: true, completion: nil)
    }
}

class SettingsDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 이용약관이나 개인정보처리방침 화면을 구현합니다.
    }
}
