import UIKit
import Lottie

class FeedController: UIViewController {
    
    private let feedTable = UITableView()
    private var feedData: [NewFeedModel] = []
    private let refreshControl = UIRefreshControl()
    private var lastText: String?
    private var remainingFeed = true
    
    private let loadView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "load")
        animation.loopMode = .loop
        return animation
    }()
    
    private let bringView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "bring")
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        setupTable()
        setupData()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // NavigationBar 숨김.
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - 테이블뷰 설정
    func setupTable() {
        feedTable.dataSource = self
        feedTable.delegate = self
        feedTable.separatorStyle = .none
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: feedTable.frame.width, height: 50))
        footerView.backgroundColor = .clear
        
        feedTable.tableFooterView = footerView
        feedTable.register(NewFeedView.self, forCellReuseIdentifier: "feedCell")
    }
    
    private func setupUI() {
        self.view.addSubviews([
            feedTable,
            loadView,
            bringView
        ])
        
        feedTable.backgroundColor = .clear
        NSLayoutConstraint.activate([
            feedTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            feedTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
            loadView.heightAnchor.constraint(equalTo: self.loadView.widthAnchor),
            
            bringView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bringView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            bringView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
            bringView.heightAnchor.constraint(equalTo: self.bringView.widthAnchor)
        ])
    }
    
    private func setupData() {
        self.bringView.isHidden = true
        self.loadView.play()
        
        FeedService.shared.getFeed(.basic) { [weak self] result in
            guard let self = self else { return }
            
            self.loadView.stop()
            self.loadView.isHidden = true
            
            switch result {
            case .success(let feeds):
                self.feedData = feeds
                self.feedTable.reloadData()
            case .failure(let error):
                AlertManager.failureFeed(on: self, with: error)
            }
        }
    }
}

// MARK: - 테이블뷰 확장 (갯수, 구성)
extension FeedController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! NewFeedView
        
        let index = indexPath.item
        
        cell.likeButtonTapped = { [weak self] documetID, likeBool in
            guard let self = self else { return }
            
            FeedService.shared.checkLike(likeBool, index, documetID) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success():
                    cell.likePost?.toggle()
                case .failure(let error):
                    AlertManager.failureFeed(on: self, with: error)
                }
            }
        }
        
        cell.reportButtonTapped = { [weak self] documentID in
            guard let self = self else { return }
            
            AlertManager.reportAlert(on: self, documentID: documentID) { [weak self] in
                guard let self = self else { return }
                
                self.feedData.removeAll { $0.documentID == documentID }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.feedTable.reloadData()
                }
            }
        }
        
        cell.feed = self.feedData[indexPath.row]
        cell.selectionStyle = .none
        
        if indexPath.row == self.feedData.count-1 {
            cell.bottomLabel.text = self.lastText
        }
        
        return cell
    }
    
}

extension FeedController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/2 + 150
        
    }
}

extension FeedController: UIScrollViewDelegate {
    
    private func setupRefreshControl() {
        refreshControl.tintColor = ThemeColor.deepPink
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.feedTable.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        self.refreshFeed()
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset < currentOffset {
            self.bringData()
        }
    }
    
    private func refreshFeed() {
        FeedService.shared.getFeed(.basic) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let feeds):
                self.feedData = feeds
                self.feedTable.reloadData()
            case .failure(let error):
                AlertManager.failureFeed(on: self, with: error)
            }
            self.lastText = nil
            self.remainingFeed = true
            self.feedTable.refreshControl?.endRefreshing()
        }
    }
    
    private func bringData() {
        if self.remainingFeed {
            self.bringView.isHidden = false
            self.bringView.play()
            
            FeedService.shared.getFeed(.additional) { [weak self] result in
                guard let self = self else { return }
                
                self.bringView.stop()
                self.bringView.isHidden = true
                
                switch result {
                case .success(let feeds):
                    self.feedData = feeds
                    self.feedTable.reloadData()
                case .failure(let error):
                    AlertManager.failureFeed(on: self, with: error)
                }
                
                FeedService.shared.checkLastPost { [weak self] bool, error in
                    guard let self = self else { return }
                    
                    if error != nil {
                        return
                    }
                    
                    if bool {
                        self.remainingFeed = false
                        self.lastText = "마지막 게시글입니다."
                    }
                }
            }
        }
    }
}
