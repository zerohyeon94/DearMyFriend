import UIKit

class MyViewController: UIViewController {

    // MARK: Properties
    let myPrfileTitleView: MyProfileTitleView = .init(frame: .zero)
    let myPrfileTitleViewHeight: CGFloat = 50
    
    // TableView
    private let feedTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // NavigationBar 숨김.
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
        setupMyProfileTitleView()
    }
    
    private func setupMyProfileTitleView() {
        view.addSubview(myPrfileTitleView)
        myPrfileTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myPrfileTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myPrfileTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPrfileTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPrfileTitleView.heightAnchor.constraint(equalToConstant: myPrfileTitleViewHeight)
        ])
    }
}
