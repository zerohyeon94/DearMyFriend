import Foundation
import UIKit

class MyViewController: UIViewController {

    private lazy var floatingButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        return button
    }()

    private lazy var writeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.alpha = 0.0
        button.addTarget(self, action: #selector(didTapWriteButton), for: .touchUpInside) // 수정된 부분
        return button
    }()

    private var isActive: Bool = false {
        didSet {
            showActionButtons()
        }
    }

    let myProfileTitleView: MyProfileTitleView = .init(frame: .zero)
    let myProfileInfoView: MyProfileInfoView = .init(frame: .zero)

    //    let myPetInfoView = MyPetInfoView()
    //    let myPostView = MyPostView()

    let myPetInfoView: MyPetInfoView = .init(frame: .zero)
    let myPostView: MyPostView = .init(frame: .zero)

    let myProfileFirestore = MyProfileFirestore() // Firebase
    var userUid: String = MyFirestore().getCurrentUser() ?? ""

    static var myProfileData: [[String: RegisterMyPetInfo]] = []
    static var myFeedData: [[String: FeedModel]] = [] // key : feed Document ID, value : 데이터

    // Height
    let myProfileTitleViewHeight: CGFloat = 50
    let myProfileInfoViewHeight: CGFloat = 150
    let topBottomConstant: CGFloat = 10
    let leftRightConstant: CGFloat = 10
    let segmentedHeight: CGFloat = 30


    private let feedTableView = UITableView()


    // segment

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["마이 프렌드", "마이 게시물"])
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
    private var animation: UIViewPropertyAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getUserFirestore()
        setUI()
        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 60 - 8 - 20, y: view.frame.size.height - 60 - 8 - 120, width: 60, height: 60)
        writeButton.frame = CGRect(x: view.frame.size.width - 60 - 8 - 20, y: view.frame.size.height - 60 - 80 - 8 - 120, width: 60, height: 60)

        // 먼저 floatingButton과 writeButton을 추가
        view.addSubview(floatingButton)
        view.addSubview(writeButton)

        // feedTableView를 앞쪽으로 가져옴
        view.bringSubviewToFront(feedTableView)
    }


    private func setUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(floatingButton)
        view.addSubview(writeButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

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

        myProfileTitleView.delegate = self

        NSLayoutConstraint.activate([
            myProfileTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myProfileTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myProfileTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myProfileTitleView.heightAnchor.constraint(equalToConstant: myProfileTitleViewHeight)
        ])
        myProfileTitleView.delegate = self
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

        myPostView.delegate = self

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
        shouldHideFirstView = false
    }

    @objc private func didTapFloatingButton() {
        isActive.toggle()
    }

    @objc private func didChangeValue(segment: UISegmentedControl) {
        shouldHideFirstView = segment.selectedSegmentIndex == 1
    }

    //petinfo에 네비게이션컨트롤로 연결
    @objc private func didTapWriteButton() {
        let petInfoVC = PetInfoViewController()
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(petInfoVC, animated: false)
    }

    private func showActionButtons() {
        popButtons()
        rotateFloatingButton()
    }

    private func popButtons() {
        if isActive {
            writeButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: { [weak self] in
                guard let self = self else { return }
                self.writeButton.layer.transform = CATransform3DIdentity
                self.writeButton.alpha = 1.0
            })
        } else {

            UIView.animate(withDuration: 0.15, delay: 0.2, options: []) { [weak self] in
                guard let self = self else { return }
                self.writeButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.1)
                self.writeButton.alpha = 0.0
            }
        }
    }

    private func rotateFloatingButton() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let fromValue = isActive ? 0 : CGFloat.pi / 4
        let toValue = isActive ? CGFloat.pi / 4 : 0
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        floatingButton.layer.add(animation, forKey: nil)
    }

    func getUserFirestore() {
        // 내 프로필 정보 표시
        myProfileInfoView.setupUserProfile()

        // 애완동물 정보 표시
        myProfileFirestore.getMyPet(uid: userUid) { myPet in

            MyViewController.myProfileData = myPet

            self.myProfileInfoView.setupUserProfile()
            self.myPetInfoView.setupTableView()
            self.myPetInfoView.reloadTableView()
        }

        // 사용자의 Feed 정보
        myProfileFirestore.getMyFeed(uid: userUid) { myFeed in
            MyViewController.myFeedData = myFeed

            self.myPostView.reloadCollectionView()
        }
    }
}

extension MyViewController: MyProfileTitleViewDelegate {
    func settingButtonTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(settingsVC, animated: false)
    }
}

extension MyViewController: MyPostViewDelegate {
    func displayFeedView(index: Int) {
        print("displayFeedView")
        let myFeedViewController = MyFeedViewController(index: index)
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(myFeedViewController, animated: true)
    }
}
