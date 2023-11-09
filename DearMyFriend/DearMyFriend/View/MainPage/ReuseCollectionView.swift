//
//  ReuseCollectionView.swift
//  DearMyFriend
//
//  Created by Macbook on 10/23/23.
//

import UIKit

class ReuseCollectionView: UIView {

    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 15)
        label.textColor = ThemeColor.titleColor
        return label
    }()
    
    let reuseCollection : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = Collection.menuSpacing

        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        addSubview(titleLabel)
        addSubview(reuseCollection)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            reuseCollection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            reuseCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            reuseCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            reuseCollection.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
