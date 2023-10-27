//
//  PopularityCellView.swift
//  DearMyFriend
//
//  Created by Macbook on 10/24/23.
//

import UIKit

class PopularityCellView: UICollectionViewCell {

    var toucheOfImage: (PopularityCellView)->() = { PopularityCellView in }
    
    // 사진
    let petPhoto: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .systemOrange
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    
    // 프로필 이미지
    let profileView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemBlue
        image.clipsToBounds = true
        image.layer.cornerRadius = IndicatorInfo.size/2
        return image
    }()
    
    // 이름 + 종(예시 : 랙돌)
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 15)
        label.text = "ryusdb"
        return label
    }()
    
    // 인디게이터 바
    let indicatorCircle: IndicatorCircle = {
        let indicator = IndicatorCircle()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileView, nameLabel, indicatorCircle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    // 하트 버튼
    lazy var subscribeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let buttonImage = UIImage(systemName: "heart", withConfiguration: imageConfig)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        self.contentView.addSubviews([
            petPhoto,
            topStackView,
            subscribeButton,
        ])
        
        NSLayoutConstraint.activate([
            petPhoto.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            petPhoto.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            petPhoto.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            petPhoto.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            
            topStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            topStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            topStackView.heightAnchor.constraint(equalToConstant: IndicatorInfo.size),
            
            profileView.widthAnchor.constraint(equalToConstant: IndicatorInfo.size),
            
            indicatorCircle.topAnchor.constraint(equalTo: topStackView.topAnchor),
            indicatorCircle.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
            indicatorCircle.widthAnchor.constraint(equalToConstant: IndicatorInfo.size),
            indicatorCircle.heightAnchor.constraint(equalToConstant: IndicatorInfo.size),
            
            subscribeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            subscribeButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            subscribeButton.widthAnchor.constraint(equalToConstant: IndicatorInfo.size),
            subscribeButton.heightAnchor.constraint(equalToConstant: IndicatorInfo.size),
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        PopularityTouch.touch = true
        self.toucheOfImage(self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        PopularityTouch.touch = false
        self.toucheOfImage(self)
    }
    
}
