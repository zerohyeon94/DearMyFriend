import UIKit

class MainMenuCellView: UICollectionViewCell {
    
    let imageView: UIImageView = {
       let view = UIImageView()
        view.tintColor = .black
        return view
    }()
    
    var imageUrl: String? {
        didSet {
            guard let imageUrl = imageUrl else { return }
            imageView.image = UIImage(systemName: imageUrl)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.backgroundColor = .gray
        autoLayout()
        makeBounds()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    
    func makeBounds() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
}
