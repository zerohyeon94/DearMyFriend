import UIKit
import Lottie

class CommentController: UIViewController {
    
    private let commentView = CommentListView()
    private let commentTable = UITableView()
    public var documentID: String?
    private var isKeyboardUp = false
    
    
    public var commentList:[CommentModel] = []
    
    private let bringView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "bring")
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        return animation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNaviBar()
        setupUI()
        setupTable()
        setupPresent()
        setupAction()
    }
    
    private func setupNaviBar() {
        title = "댓글"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTable() {
        commentView.commentTable.backgroundColor = .white
        commentView.commentTable.dataSource = self
        commentView.commentTable.delegate = self
        commentView.commentTable.separatorStyle = .none
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: commentTable.frame.width, height: 20))
        footerView.backgroundColor = .clear
        
        commentView.commentTable.tableFooterView = footerView
        commentView.commentTable.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func setupUI() {
        self.view.addSubviews([commentView, bringView])
        
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            commentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            commentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            bringView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bringView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            bringView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/3),
            bringView.heightAnchor.constraint(equalTo: self.bringView.widthAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupData() {
        self.bringView.play()
        
        
        guard let documentID = self.documentID else { return }
        CommentService.shared.getComment(documentID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let commentList):
                self.bringView.stop()
                self.bringView.isHidden = true
                
                self.commentList = commentList
                self.commentView.commentTable.reloadData()
                if commentList.count > 5 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.commentView.commentTable.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            case .failure(let error):
                AlertManager.failureFeed(on: self, with: error)
            }
        }
    }
    
    private func setupPresent() {
        if let presentationController = self.presentationController {
            presentationController.delegate = self
        }
    }
    
    private func setupAction() {
        self.commentView.sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func sendButtonTapped() {
        let comment = self.commentView.commentTextField.text ?? ""
        guard let documentID = self.documentID else { return }
        CommentService.shared.commentDataUpdateDB(comment, documentID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success():
                self.bringView.isHidden = false
                self.commentView.commentTextField.text = nil
                self.commentView.sendButton.isEnabled = false
                self.setupData()
            case .failure(let error):
                AlertManager.failureFeed(on: self, with: error)
            }
        }
    }
}

extension CommentController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        cell.comment = commentList[indexPath.item]
        cell.selectionStyle = .none
        
        cell.reportButtonTapped = { [weak self] comment in
            guard let self = self else { return }
            
            guard let documentID = self.documentID else { return }

            AlertManager.reportCommentAlert(on: self, comment, documentID)
        }
        
        return cell
    }
    
}

extension CommentController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/15
        
    }
}

extension CommentController {
    
    @objc func keyboardUp(notification:NSNotification) {
        if !isKeyboardUp, let keyboardFrame:NSValue =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            isKeyboardUp = true
            let keyboardRectangle = keyboardFrame.cgRectValue.height
            
            UIView.animate(withDuration: 0.03, animations: {
                self.commentView.commentSV.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle)
                self.commentView.sendButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle)
                self.commentView.spacerView3.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle)
            }
            )
        }
    }
    
    @objc func keyboardDown() {
        isKeyboardUp = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.commentView.commentSV.transform  = .identity
                self.commentView.sendButton.transform = .identity
                self.commentView.spacerView3.transform = .identity
            }
        )
    }
}

extension CommentController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        self.keyboardDown()
    }
}
