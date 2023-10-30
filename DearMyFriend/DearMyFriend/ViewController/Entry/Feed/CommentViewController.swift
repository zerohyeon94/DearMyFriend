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
        let commentCellHeight: CGFloat = CommentView().calCommentViewHeight() + 10 // Cell의 여유분의 높이 10을 줌.
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.selectionStyle = .none // cell 선택 효과 없애기
        
        return cell
    }
}
