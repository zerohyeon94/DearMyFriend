import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let settingsOptions = ["이용약관", "개인정보처리방침", "회원탈퇴", "로그아웃"]
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
            showDetailViewController(title: "이용약관")
        case 1:
            if let url = URL(string: "https://www.notion.so/dcab8c95d6c848288127665f397e09ad?pvs=4") {
                let webVC = UIViewController()
                let webView = UIWebView(frame: webVC.view.bounds)
                webView.loadRequest(URLRequest(url: url))
                webVC.view.addSubview(webView)
                webView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    webView.topAnchor.constraint(equalTo: webVC.view.safeAreaLayoutGuide.topAnchor),
                    webView.leadingAnchor.constraint(equalTo: webVC.view.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: webVC.view.trailingAnchor),
                    webView.bottomAnchor.constraint(equalTo: webVC.view.bottomAnchor)
                ])
                webVC.title = "개인정보처리방침"
                navigationController?.pushViewController(webVC, animated: true)
            }
        case 2:
            showWithdrawalAlert()
        case 3:
            showLogoutAlert()
        default:
            break
        }
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
            AuthService.shared.deleteAccount { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print("탈퇴 실패", error)
                } else {
                    print("탈퇴 성공")
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
}

class SettingsDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 이용약관이나 개인정보처리방침 화면을 구현합니다.
    }
}
