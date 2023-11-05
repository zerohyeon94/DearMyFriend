import UIKit

class MainMenuCellView: UICollectionViewCell {
    //
    var iconSet: [String: UIImage?]? {
        didSet {
            guard let imageSet = iconSet else { return }
            guard let image = imageSet.values.first else { return }
            menuTitle.text = imageSet.keys.first
//            menuIcon.image = image
        }
    }
    
    let menuIcon: UIImageView = {
       let view = UIImageView()
        view.tintColor = .white
        view.backgroundColor = ThemeColor.deepPink
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var menuTitle: UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = ThemeColor.deepTextColor
        title.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 10)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        autoLayout()
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
            menuIcon.widthAnchor.constraint(equalToConstant: Collection.menuSize),
            menuIcon.heightAnchor.constraint(equalTo: self.menuIcon.widthAnchor),
            
            menuTitle.topAnchor.constraint(equalTo: menuIcon.bottomAnchor, constant: 5),
            menuTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
