//
//  CommentCell.swift
//  DearMyFriend
//
//  Created by Macbook on 11/15/23.
//

import UIKit

class CommentCell: UITableViewCell {
    
    public var reportButtonTapped: ((String) -> Void) = { comment in }
    
    public var comment: CommentModel? {
        didSet {
            guard let comment = comment else { return }
            self.profileView.image = comment.profileImage
            self.userNameLabel.text = comment.userName
            self.commentLabel.text = comment.comment
        }
    }
    
    private let profileView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.titleColor
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 13)
        label.text = "Error"
        label.backgroundColor = .clear
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.titleColor
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13)
        label.text = "Error"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var labelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [userNameLabel, commentLabel])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    private lazy var commentSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileView, labelSV, reportButton])
        sv.spacing = 10
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    private lazy var reportButton: UIButton = {
        
        let heart = UIImage(systemName: "exclamationmark.circle") ?? UIImage()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .light, scale: .large)
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        config.image = heart.applyingSymbolConfiguration(imageConfig)
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(reportButtonTapped(_:)), for: .touchUpInside)
        button.tintColor = ThemeColor.titleColor
        return button
    }()

    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileView.layer.cornerRadius = self.profileView.frame.height/2
        
        let verticalSpacing: CGFloat = 10    // 상하 간격
        
        var contentViewFrame = contentView.frame
        
        contentViewFrame.origin.y += verticalSpacing
        contentViewFrame.size.height -= verticalSpacing * 2
        
        contentView.frame = contentViewFrame
    }
    // MARK: - UI Setup
    private func autoLayout() {
        self.contentView.addSubviews([commentSV])
        
        NSLayoutConstraint.activate([
            commentSV.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            commentSV.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            commentSV.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            commentSV.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            profileView.widthAnchor.constraint(equalTo: self.commentSV.heightAnchor),
            reportButton.trailingAnchor.constraint(equalTo: self.commentSV.trailingAnchor),
            reportButton.widthAnchor.constraint(equalTo: self.commentSV.heightAnchor)
        ])
    }
    
    @objc
    private func reportButtonTapped(_ sender: UIButton) {
        guard let comment = comment?.comment else { return }
        reportButtonTapped(comment)
    }
}
