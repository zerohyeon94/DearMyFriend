import UIKit

class MyViewController: UIViewController {

    // MARK: Properties
    let myPrfileTitleView: MyProfileTitleView = .init(frame: .zero)
    let myPrfileInfoView: MyProfileInfoView = .init(frame: .zero)
    let myPrfileTitleViewHeight: CGFloat = 50
    let myPrfileInfoViewHeight: CGFloat = 150
    
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
        setupMyProfileInfoView()
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
    
    private func setupMyProfileInfoView() {
        view.addSubview(myPrfileInfoView)
        myPrfileInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myPrfileInfoView.topAnchor.constraint(equalTo: myPrfileTitleView.bottomAnchor),
            myPrfileInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPrfileInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPrfileInfoView.heightAnchor.constraint(equalToConstant: myPrfileInfoViewHeight)
        ])
    }
}
