import UIKit

class FeedViewController: UIViewController {
    
    // MARK: Properties
    let feedTitleView: FeedTitleView = .init(frame: .zero)
    let feedTitleViewHeight: CGFloat = 50
    let myFirestore = MyFirestore() // Firebase
    
    // TableView
    private let feedTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
//        subscribeFirestore()
//        getFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // NavigationBar 숨김.
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
        setupFeedTitleView()
        setupTableView()
    }
    
    private func setupFeedTitleView() {
        view.addSubview(feedTitleView)
        feedTitleView.translatesAutoresizingMaskIntoConstraints = false
        feedTitleView.delegate = self // UIView와 UIViewController 간의 통신을 설정하는 부분. 그리하여 UIView클래스에서 Delegate 프로토콜을 정의하고 Delegate 프로퍼티를 선언하더라도, UIViewController에서 Delegate를 설정하지 않는다면 UIView에서 발생한 이벤트가 UIViewController로 전달되지 않는다.
        
        NSLayoutConstraint.activate([
            feedTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTitleView.heightAnchor.constraint(equalToConstant: feedTitleViewHeight)
        ])
    }
    
    func setupTableView(){
        feedTableView.dataSource = self
        
        feedTableView.separatorStyle = .none // Cell 사이 줄 제거
        
        let feedCellHeight: CGFloat = FeedView().calFeedViewHeight() + 10 // Cell의 여유분의 높이 10을 줌.
        
        feedTableView.rowHeight = feedCellHeight
        
        feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        view.addSubview(feedTableView)
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feedTableView.topAnchor.constraint(equalTo: feedTitleView.bottomAnchor),
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
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
        print("getFirestore")
        myFirestore.getFeed()
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // 추후 받아오는 데이터 정보에 따라 표시되는 수 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = .none // cell 선택 효과 없애기
        
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
