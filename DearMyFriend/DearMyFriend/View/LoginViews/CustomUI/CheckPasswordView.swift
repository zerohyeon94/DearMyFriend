//
//  CheckPasswordView.swift
//  DearMyFriend
//
//  Created by Macbook on 11/6/23.
//

import UIKit

class CheckPasswordView: UIView {
    
    public var colorBool = false
    
    private let checkImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.tintColor = .systemGray
        view.image = ButtonConfig.checkIcon
        return view
    }()
    
    private let checkName: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .systemGray
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13)
        label.text = "Error"
        return label
    }()
    
    private lazy var checkStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [checkImage, checkName])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        return sv
    }()
    
    
    init(_ title: String, _ font: UIFont?) {
        super.init(frame: .zero)
        self.checkName.text = title
        self.checkName.font = font
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubviews([
            checkStackView
        ])
        
        NSLayoutConstraint.activate([
            self.checkStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.checkStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.checkStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.checkStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.checkImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    public func changeColor() {
        if !colorBool {
            self.checkImage.image = ButtonConfig.checkFillIcon
            self.checkImage.tintColor = ThemeColor.deepPink
        } else {
            self.checkImage.image = ButtonConfig.checkIcon
            self.checkImage.tintColor = .systemGray
        }
        colorBool.toggle()
    }
    
    public func validTrueColor() {
        if !colorBool {
            self.checkImage.image = ButtonConfig.checkFillIcon
            self.checkImage.tintColor = ThemeColor.deepPink
            colorBool.toggle()
        }
    }
    
    public func validFalseColor() {
        if colorBool {
            self.checkImage.image = ButtonConfig.checkIcon
            self.checkImage.tintColor = .systemGray
            colorBool.toggle()
        }
    }
}
