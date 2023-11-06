import UIKit

class MainMenuCellView: UICollectionViewCell {

    var iconSet: [String: UIImage?]? {
        didSet {
            guard let imageSet = iconSet else { return }
            guard let image = imageSet.values.first else { return }
            menuTitle.text = imageSet.keys.first
            menuIcon.image = image
            autoLayout(Collection.menuSize)
        }
    }
    
    var appStore: SearchResult? {
        didSet {
            guard let appStore = appStore else { return }
            loadImage(appStore)
            menuTitle.text = appStore.appName
            autoLayout(Collection.reuseStoreWidtSize)
        }
    }
    
    let menuIcon: UIImageView = {
       let view = UIImageView()
        view.tintColor = .white
        view.backgroundColor = ThemeColor.pink
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
        title.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 10)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.menuIcon.image = nil
    }
    
    func autoLayout(_ cellSize :Int) {
        self.contentView.addSubview(menuIcon)
        self.contentView.addSubview(menuTitle)
        NSLayoutConstraint.activate([
            menuIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            menuIcon.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            menuIcon.widthAnchor.constraint(equalToConstant: CGFloat(cellSize)),
            menuIcon.heightAnchor.constraint(equalTo: self.menuIcon.widthAnchor),
            
            menuTitle.topAnchor.constraint(equalTo: menuIcon.bottomAnchor, constant: 5),
            menuTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func loadImage(_ myApp: SearchResult) {
        guard let myAppImage = myApp.appImage else { return }
        guard let url = URL(string: myAppImage)  else { return }

        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                self.menuIcon.image = UIImage()
                return
            }
            guard self.appStore?.appImage == url.absoluteString else { return }
            DispatchQueue.main.async {
                self.menuIcon.image = UIImage(data: data)
            }
        }
    }
    

}
