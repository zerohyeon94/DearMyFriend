//
//  RegiSterProfileView.swift
//  DearMyFriend
//
//  Created by Macbook on 11/6/23.
//

import UIKit

class RegisterProfileView: UIView {
    
    public let pickerView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = ThemeColor.pink
        view.image = UIImage(named: "map")
        view.clipsToBounds = true
        view.layer.cornerRadius = 55/2
        return view
    }()
    
    public let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = ThemeColor.titleColor
        view.image = ButtonConfig.cameraIcon
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = ThemeColor.deepPink
        return view
    }()
    
    let usernameField = SignTextField(fieldType: .username)
    
    lazy var profileStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [pickerView, usernameField])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    
    private let informationText: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13)
        label.text = "내새꾸와 관련된 닉네임을 추천드려요!"
        return label
    }()
    
    let signInButton = SignButton(title: "다음", hasBackground: true, fontSize: .complete)
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .systemBackground
        
        self.addSubviews([
            profileStackView,
            cameraImageView,
            informationText,
            signInButton,
        ])
        
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            profileStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            profileStackView.heightAnchor.constraint(equalToConstant: 55),
            
            pickerView.widthAnchor.constraint(equalTo: self.profileStackView.heightAnchor),
            
            cameraImageView.trailingAnchor.constraint(equalTo: self.pickerView.trailingAnchor),
            cameraImageView.bottomAnchor.constraint(equalTo: self.pickerView.bottomAnchor),
            cameraImageView.widthAnchor.constraint(equalToConstant: 20),
            cameraImageView.heightAnchor.constraint(equalToConstant: 20),
            
            informationText.topAnchor.constraint(equalTo: self.profileStackView.bottomAnchor, constant: 10),
            informationText.leadingAnchor.constraint(equalTo: self.usernameField.leadingAnchor, constant: 10),
            
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
