import UIKit

class MyViewController: UIViewController {
    
    // MARK: Properties
    let myProfileTitleView: MyProfileTitleView = .init(frame: .zero)
    let myProfileInfoView: MyProfileInfoView = .init(frame: .zero)
    let myPetInfoView: MyPetInfoView = .init(frame: .zero)
    let myPostView: MyPostView = .init(frame: .zero)
    // Height
    let myProfileTitleViewHeight: CGFloat = 50
    let myProfileInfoViewHeight: CGFloat = 150
    // Segmented Control
    let topBottomConstant: CGFloat = 10
    let leftRightConstant: CGFloat = 10
    let segmentedHeight: CGFloat = 30
    
    // TableView
    private let feedTableView = UITableView()
    
    // segment
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["myPetInfoView", "myPostView"])
        
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    var shouldHideFirstView: Bool? {
        didSet {
            guard let shouldHideFirstView = self.shouldHideFirstView else { return }
            myPetInfoView.isHidden = shouldHideFirstView
            myPostView.isHidden = !shouldHideFirstView
        }
    }
    
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
        setupSegmentedControl()
        setupSegmentedViews()
    }
    
    private func setupMyProfileTitleView() {
        view.addSubview(myProfileTitleView)
        myProfileTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myProfileTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myProfileTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myProfileTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myProfileTitleView.heightAnchor.constraint(equalToConstant: myProfileTitleViewHeight)
        ])
    }
    
    private func setupMyProfileInfoView() {
        view.addSubview(myProfileInfoView)
        myProfileInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myProfileInfoView.topAnchor.constraint(equalTo: myProfileTitleView.bottomAnchor),
            myProfileInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myProfileInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myProfileInfoView.heightAnchor.constraint(equalToConstant: myProfileInfoViewHeight)
        ])
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: myProfileInfoView.bottomAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: segmentedHeight)
        ])
    }
    
    private func setupSegmentedViews() {
        view.addSubview(myPetInfoView)
        view.addSubview(myPostView)
        myPetInfoView.translatesAutoresizingMaskIntoConstraints = false
        myPostView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myPetInfoView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            myPetInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPetInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPetInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            myPostView.topAnchor.constraint(equalTo: myPetInfoView.topAnchor),
            myPostView.leadingAnchor.constraint(equalTo: myPetInfoView.leadingAnchor),
            myPostView.trailingAnchor.constraint(equalTo: myPetInfoView.trailingAnchor),
            myPostView.bottomAnchor.constraint(equalTo: myPetInfoView.bottomAnchor),
        ])
        
        shouldHideFirstView = false // 초기 View 설정
    }
    
    // MARK: Action
    @objc private func didChangeValue(segment: UISegmentedControl) {
        shouldHideFirstView = segment.selectedSegmentIndex == 1
    }
}
