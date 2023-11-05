import Foundation
import UIKit

class MyPostCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyPostCollectionViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraint()
    }
    
    private func setUI() {
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: topAnchor),
            postImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setPostImageView(with image: String) {
        postImageView.image = UIImage(named: image)
    }
}
