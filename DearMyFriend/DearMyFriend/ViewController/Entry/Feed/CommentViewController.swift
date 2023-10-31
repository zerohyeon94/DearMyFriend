//
//  CommentViewController.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/30.
//

import Foundation
import UIKit

class CommentViewController: UIViewController {
    // MARK: Properties
    let commentTitleView: CommentTitleView = .init(frame: .zero)
    let feedTitleViewHeight: CGFloat = 50
    
    // TableView
    private let commentTableView = UITableView()
    
    let index: Int
    
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
    
    // MARK: Configure
    private func configure() {
        view.backgroundColor = .white
        setupFeedTitleView()
        setupTableView()
    }
    
    private func setupFeedTitleView() {
        view.addSubview(commentTitleView)
        commentTitleView.translatesAutoresizingMaskIntoConstraints = false
        commentTitleView.delegate = self
        
        NSLayoutConstraint.activate([
            commentTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            commentTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentTitleView.heightAnchor.constraint(equalToConstant: feedTitleViewHeight)
        ])
    }
    
    func setupTableView(){
        commentTableView.dataSource = self
//        commentTableView.separatorStyle = .none // Cell 사이 줄 제거
        print("CommentView().calCommentViewHeight(): \(CommentView().calCommentViewHeight())")
        let commentCellHeight: CGFloat = CommentView().calCommentViewHeight() + 10 // Cell의 여유분의 높이 10을 줌.
        print("commentCellHeight: \(commentCellHeight)")
        commentTableView.rowHeight = commentCellHeight
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        view.addSubview(commentTableView)
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: commentTitleView.bottomAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CommentViewController: CommentTitleViewDelegate {
    func endButtonTapped() {
        dismiss(animated: true)
    }
}

extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 현재 Feed에 가져온 정보 확인.
        var feedCellIndex: Int = index
        var feedDataValue: [[String: String]] // 위의 Document ID 내 필드값 중 댓글
        if let feedData = FeedViewController.feedDatas[index].values.first?.comment {
            feedDataValue = feedData
        } else {
            // 값이 없는 경우에 대한 처리
            feedDataValue = [[:]]
        }
        
        return feedDataValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.selectionStyle = .none // cell 선택 효과 없애기
        
        // 현재 Feed에 가져온 정보 확인.
        var feedCellIndex: Int = index
        var feedDataKey: String // 업로드된 시간 -> Feed 내 Document ID
        if let firstKey = FeedViewController.feedDatas[index].keys.first {
            feedDataKey = firstKey
        } else {
            // 값이 없는 경우에 대한 처리
            feedDataKey = "" // 또는 다른 기본값
        }
        var feedDataValue: [String: String] // 위의 Document ID 내 필드값 중 댓글
        if let feedData = FeedViewController.feedDatas[index].values.first?.comment[indexPath.row] {
            feedDataValue = feedData
        } else {
            // 값이 없는 경우에 대한 처리
            feedDataValue = [:]
        }
        
        cell.setComment(comment: feedDataValue)
        
        return cell
    }
}
