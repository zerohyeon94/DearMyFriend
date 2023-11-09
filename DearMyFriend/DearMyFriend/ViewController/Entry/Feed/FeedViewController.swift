import UIKit
import Lottie
import FirebaseAuth

class FeedViewController: UIViewController {
    
    // MARK: Properties
    let feedTitleView: FeedTitleView = .init(frame: .zero)
    let feedTitleViewHeight: CGFloat = 50
    let myFirestore = MyFirestore() // Firebase
    
    // TableView
    private let feedTableView = UITableView()
    // Feed Data
    static var feedDatas: [[String: FeedData]] = []
    static var allFeedData: [FeedModel] = []
    
    lazy var loadingView = {
        let animeView = LottieAnimationView(name: "loading")
        
        animeView.contentMode = .scaleAspectFit
        animeView.loopMode = .loop
        animeView.animationSpeed = 1
        animeView.play()
        
        return animeView
    }()
    
    // MARK: FloatingButton
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

    private let writeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.alpha = 0.0
        button.addTarget(self, action: #selector(didTapWriteFloatingButton), for: .touchUpInside)
        return button
    }()
    
    private var isActive: Bool = false {
        didSet {
            showActionButtons()
        }
    }
    
    private var animation: UIViewPropertyAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        //        subscribeFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // NavigationBar 숨김.
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 60 - 8 - 20, y: view.frame.size.height - 60 - 8 - 40 - 50, width: 60, height: 60)
        writeButton.frame = CGRect(x: view.frame.size.width - 60 - 8 - 20, y: view.frame.size.height - 60 - 80 - 8 - 40 - 50, width: 60, height: 60)
    }
    
    private func setupFloatingButton() {
        view.backgroundColor = .systemBackground
        view.addSubview(floatingButton)
        view.addSubview(writeButton)
    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
//        setupFeedTitleView()
        subscribeFirestore()
        getFirestore() // Firestore에 있는 정보 가져와서 TableView 표시
    }
    
    private func setupLoading() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            loadingView.topAnchor.constraint(equalTo: feedTitleView.bottomAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 150),
            loadingView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    private func setupFeedTitleView() {
        view.addSubview(feedTitleView)
        feedTitleView.translatesAutoresizingMaskIntoConstraints = false
        feedTitleView.delegate = self // UIView와 UIViewController 간의 통신을 설정하는 부분. 그리하여 UIView클래스에서 Delegate 프로토콜을 정의하고 Delegate 프로퍼티를 선언하더라도, UIViewController에서 Delegate를 설정하지 않는다면 UIView에서 발생한 이벤트가 UIViewController로 전달되지 않는다.
        // 현재 로그인 되어있는 ID 확인. - 추후 구현
        feedTitleView.userNicknameLabel.text = "내 새끼 자랑"
        
        NSLayoutConstraint.activate([
            feedTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTitleView.heightAnchor.constraint(equalToConstant: feedTitleViewHeight)
        ])
    }
    
    func setupTableView(){
        print("FeedViewController.allFeedData: \(FeedViewController.allFeedData)")
        
        feedTableView.dataSource = self
        feedTableView.separatorStyle = .none
        
        let feedCellHeight: CGFloat = FeedView().calFeedViewHeight() + 10 // Cell의 여유분의 높이 10을 줌.
        feedTableView.rowHeight = feedCellHeight
        feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        view.addSubview(feedTableView)
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            feedTableView.topAnchor.constraint(equalTo: feedTitleView.bottomAnchor),
            feedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Firestore 업데이트 여부
    private func subscribeFirestore() {
        print("subscribeFirestore")
        myFirestore.subscribe(collection: MyFirestore().collectionInfo, id: "_zerohyeon") { [weak self] result in
            switch result {
            case .success(let messages):
                print("subscribeFirestore success")
                print("message: \(messages)")
            case .failure(let error):
                print("subscribeFirestore failure")
                print(error)
            }
        }
    }
    
    private func getFirestore() {
        setupLoading()
        
//        myFirestore.getModelFeed { feedAllData in
//            print("feedAllData: \(feedAllData)")
//            // NEED: 만약에 데이터가 없는 경우 어떻게 표시할지 추후 구현
//            if feedAllData.isEmpty {
//                print("데이터가 없습니다!")
//            } else {
//                print("데이터가 있습니다!")
//            }
//
//            FeedViewController.feedDatas = feedAllData
//
//            // 데이터 로딩이 완료되면 로딩 애니메이션 숨기기
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
//                self.loadingView.removeFromSuperview()
//                // 테이블 뷰 설정
//                self.setupTableView()
//                self.setUI()
//            }
//        }
        
        myFirestore.getFeed { feedData in
            print("feedData: \(feedData)")
            // NEED: 만약에 데이터가 없는 경우 어떻게 표시할지 추후 구현
            if feedData.isEmpty {
                print("데이터가 없습니다!")
            } else {
                print("데이터가 있습니다!")
            }
            
            FeedViewController.allFeedData = feedData
            
            // 데이터 로딩이 완료되면 로딩 애니메이션 숨기기
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.loadingView.removeFromSuperview()
                
                self.setupTableView() // 테이블 뷰 설정
                self.setupFloatingButton() // Floating Button 설정.
            }
        }
    }
    
    // MARK: Floating Button Action
    @objc private func didTapFloatingButton() {
        isActive.toggle()
    }
    
    @objc private func didTapWriteFloatingButton() {
        let addPostViewController = AddPostViewController()
        addPostViewController.modalPresentationStyle = .fullScreen
        present(addPostViewController, animated: true, completion: nil)
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
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedViewController.allFeedData.count // 추후 받아오는 데이터 정보에 따라 표시되는 수 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = .none // cell 선택 효과 없애기
        
        cell.feedView.delegate = self
        
        // 전체 데이터 중 순서대로 나열
        let indexData: FeedModel = FeedViewController.allFeedData[indexPath.row] // 형태 [String: FeedData]
        print("indexData: \(indexData)")
        cell.cellIndex = indexPath.row
        
        cell.setFeed(feedData: indexData, index: indexPath.row)
        
        return cell
    }
}

extension FeedViewController: FeadTitleViewDelegate {
    func addButtonTapped() {
        let addPostViewController = AddPostViewController()
        addPostViewController.modalPresentationStyle = .fullScreen
        present(addPostViewController, animated: true, completion: nil)
    }
}

extension FeedViewController: FeedViewDelegate {
    func likeButtonTapped() {
        print("likeButtonTapped")
        
        // 좋아요 버튼을 누르고 새롭게 받은 데이터를 최신화해준다.
        myFirestore.getModelFeed { feedAllData in
            
            print("feedAllData: \(feedAllData)")
            
            FeedViewController.feedDatas = feedAllData
            
            self.setupTableView()
        }
    }
    
    func commentButtonTapped(index: Int) {
        print("commentButtonTapped : \(index)")
        
        let commentViewController = CommentViewController(index: index)
        commentViewController.modalPresentationStyle = .fullScreen
        present(commentViewController, animated: true, completion: nil)
    }
}
