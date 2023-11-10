//
//  CommentViewController.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/30.
//

import Foundation
import UIKit
import FirebaseFirestore

class CommentViewController: UIViewController {
    // MARK: Properties
    let commentTitleView: CommentTitleView = .init(frame: .zero)
    let commentInputView: CommentInputView = .init(frame: .zero)
    let commentTitleViewHeight: CGFloat = 50
    let commentInputViewHeight: CGFloat = 50
    
    // TableView
    private let commentTableView = UITableView()
    // commentInputView의 위치
    var commentInputVewYPosition: CGFloat = 0
    // CommentViewController 클래스 내에서 필요한 변수 추가
    var isKeyboardShown = false
    var keyboardHeight: CGFloat = 0  // 클래스 레벨 변수로 선언
    
    let index: Int
    
    // MARK: Initalizers
    init(index: Int){
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // CommentViewController 클래스 내에서 viewWillAppear(_:) 함수 추가
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 키보드 관련 Notification 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // CommentViewController 클래스 내에서 viewWillDisappear(_:) 함수 추가
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 화면이 나갈 때 Notification 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
        setupCommentTitleView()
        setupTableView()
        setupCommentInputView()
    }
    
    // MARK: - Constant
    let commentInpuSideSpaceConstant: CGFloat = 20
    
    private func setupCommentTitleView() {
        view.addSubview(commentTitleView)
        commentTitleView.translatesAutoresizingMaskIntoConstraints = false
        commentTitleView.delegate = self
        
        NSLayoutConstraint.activate([
            commentTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            commentTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentTitleView.heightAnchor.constraint(equalToConstant: commentTitleViewHeight)
        ])
    }
    
    func setupTableView(){
        commentTableView.dataSource = self
        //        commentTableView.separatorStyle = .none // Cell 사이 줄 제거
        
        // 테이블 뷰에 터치 제스처를 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        commentTableView.addGestureRecognizer(tapGesture)
        
        print("CommentView().calCommentViewHeight(): \(CommentView().calCommentViewHeight())")
        let commentCellHeight: CGFloat = CommentView().calCommentViewHeight() + 10 // Cell의 여유분의 높이 10을 줌.
        print("commentCellHeight: \(commentCellHeight)")
        commentTableView.rowHeight = commentCellHeight
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        setTableViewConstraints()
    }
    
    func reloadTableView() {
        commentTableView.dataSource = self
        commentTableView.reloadData()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // 테이블 뷰를 터치했을 때 키보드를 숨깁니다.
        view.endEditing(true)
    }
    
    func setTableViewConstraints() {
        view.addSubview(commentTableView)
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: commentTitleView.bottomAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupCommentInputView() {
        view.addSubview(commentInputView)
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        commentInputView.delegate = self
        
        NSLayoutConstraint.activate([
            commentInputView.topAnchor.constraint(equalTo: commentTableView.bottomAnchor),
            commentInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: commentInpuSideSpaceConstant),
            commentInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -commentInpuSideSpaceConstant),
            commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commentInputView.heightAnchor.constraint(equalToConstant: commentInputViewHeight)
        ])
    }
    
    // MARK: Action
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { // 현재동작하는 키보드의 frame을 받아옴.
            return
        }
        self.commentInputView.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        print("hide")
        self.commentInputView.transform = .identity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension CommentViewController: CommentTitleViewDelegate {
    func endButtonTapped() {
        dismiss(animated: true)
    }
}

extension CommentViewController: CommentInputViewDelegate {
    func commentSendButtonTapped(){
        print("send the Comment")
        
        // index값을 얻어왔으니까, Feed 정보 중 몇번째인지 확인.
        var selectedFeedId: String //Feed 고유 ID (Document ID)
        if let firstKey = FeedViewController.allFeedData[index].keys.first { // 받은 Feed 데이터 중에서 몇번째에 해당하는지 tableViewCellindex 값으로 확인.
            selectedFeedId = firstKey
        } else {
            // 값이 없는 경우에 대한 처리
            selectedFeedId = "" // 또는 다른 기본값
        }
        
        var selectedFeedData: FeedModel // 위의 Document ID 내 필드값.
        if let feedData = FeedViewController.allFeedData[index].values.first {
            selectedFeedData = feedData
        } else {
            // 값이 없는 경우에 대한 처리
            selectedFeedData = FeedModel(uid: "", date: Date(), imageUrl: [], post: "", like: [], likeCount: 0, comment: [])
        }
        
        // 현재 로그인 되어있는 ID 가져옴.
        var id: String = MyFirestore().getCurrentUser() ?? ""
        var commentText: String = commentInputView.commentTextField.text!
        // 좋아요 정보가 담겨있는 배열에 로그인되어있는 ID가 있는지 확인.
        print("id: \(id)")
        print("comment text: \(commentInputView.commentTextField.text)")
        selectedFeedData.comment.append([id: commentText])
        
        // Firestore에 업데이트
        MyFirestore().updateFeedCommentData(documentID: selectedFeedId, updateFeedData: selectedFeedData)
        // 업데이트 이후 데이터 받아서 댓글창 초기화
        MyFirestore().getFeedComment(documentID: selectedFeedId) { comment in
            
            // Optional chaining
            if var firstValue = FeedViewController.allFeedData[self.index].values.first {
                firstValue.comment = comment
                
                // 현재 데이터를 가지고 있는 index
                let nowIndex = FeedViewController.allFeedData[self.index].values.startIndex
                
                // 변경된 값을 다시 할당
                FeedViewController.allFeedData[self.index].values[nowIndex] = firstValue
            }
            
            self.reloadTableView()
        }
        
    }
}

extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var feedCommentData: [[String: String]] // Feed 데이터의 필드값 중 Comment
        if let feedData = FeedViewController.allFeedData[index].values.first?.comment { // 받은 Feed 데이터 중에서 몇번째에 해당하는지 index 값으로 확인.
            feedCommentData = feedData
        } else {
            // 값이 없는 경우에 대한 처리
            feedCommentData = [[:]]
        }
        
        return feedCommentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.selectionStyle = .none // cell 선택 효과 없애기
        
        // 현재 Feed에 가져온 정보 확인.
        var feedIdD: String // Feed의 고유 ID (Document ID)
        if let firstKey = FeedViewController.allFeedData[index].keys.first {
            feedIdD = firstKey
        } else {
            // 값이 없는 경우에 대한 처리
            feedIdD = "" // 또는 다른 기본값
        }
        var feedCommentData: [String: String] // Feed 데이터의 필드값 중 Comment
        if let feedData = FeedViewController.allFeedData[index].values.first?.comment[indexPath.row] {
            feedCommentData = feedData
        } else {
            // 값이 없는 경우에 대한 처리
            feedCommentData = [:]
        }
        
        cell.setComment(comment: feedCommentData)
        
        return cell
    }
}

// 현재 응답받는 UI를 알아내기 위해 사용 (textfield, textview 등)
extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static var currentResponder: UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}
