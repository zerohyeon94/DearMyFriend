//
//  CommentView.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/30.
//

import Foundation
import UIKit

class CommentView: UIView {
    // MARK: Properties
    // Profile ImageView & Label
    let profileImageFrame: CGFloat = 20
    let profileLabelSize: CGFloat = 18
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: profileImageFrame, height: profileImageFrame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider1")
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = profileImageFrame / 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: profileLabelSize)
        label.text = "Profile name"
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: profileLabelSize)
        label.text = "Comment~~~~"
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI(){
        [profileImageView, profileLabel, commentLabel].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setProfileImageViewConstraint()
        setProfileLabelConstraint()
        setCommentLabelConstraint()
    }
    
    // MARK: - Constant
    // Profile Image
    let profileHeight: CGFloat = 30
    let profileWidth: CGFloat = 30
    // Profile Label
    let profileLeadingConstant: CGFloat = 10
    // Comment Label
    let commentHeight: CGFloat = 30
    
    private func setProfileImageViewConstraint() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: profileHeight),
            profileImageView.widthAnchor.constraint(equalToConstant: profileWidth)
        ])
    }
    
    private func setProfileLabelConstraint() {
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: topAnchor),
            profileLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: profileLeadingConstant),
            profileLabel.heightAnchor.constraint(equalToConstant: profileHeight)
        ])
    }
    
    private func setCommentLabelConstraint() {
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentLabel.heightAnchor.constraint(equalToConstant: commentHeight)
        ])
    }
    
    // FeedView의 크기를 계산하기 위해
    func calCommentViewHeight() -> Double {
        var viewHeight: Double = 0
        
        let heights: [Double] = [profileHeight, commentHeight]
        
        heights.forEach{
            viewHeight += $0
        }
        
        return viewHeight
    }
}
