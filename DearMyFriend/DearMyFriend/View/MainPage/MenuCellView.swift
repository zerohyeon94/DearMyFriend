import UIKit

class MainMenuCellView: UICollectionViewCell {
    //
    var iconSet: [String: UIImage?]? {
        didSet {
            guard let imageSet = iconSet else { return }
            guard let image = imageSet.values.first else { return }
            menuTitle.text = imageSet.keys.first
            menuIcon.image = image
        }
    }
    
    let menuIcon: UIImageView = {
       let view = UIImageView()
        view.tintColor = .white
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var menuTitle: UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 15)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoLayout()
        makeBounds()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        self.contentView.addSubview(menuIcon)
        self.contentView.addSubview(menuTitle)
        NSLayoutConstraint.activate([
            menuIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            menuIcon.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            menuIcon.widthAnchor.constraint(equalToConstant: 50),
            
            menuTitle.topAnchor.constraint(equalTo: menuIcon.bottomAnchor),
            menuTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            menuTitle.heightAnchor.constraint(equalToConstant: 20),
            menuTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func makeBounds() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
}
