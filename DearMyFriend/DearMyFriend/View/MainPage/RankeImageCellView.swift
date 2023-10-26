import UIKit

class RankImageCellView: UICollectionViewCell {
    
    var appStore: SearchResult? {
        didSet {
            guard let appStore = appStore else { return }
            loadImage(appStore)
            appTitle.text = appStore.appName
        }
    }
    
    let myImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
//        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let appTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 15)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(appTitle)
        
        
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            myImageView.bottomAnchor.constraint(equalTo: appTitle.topAnchor),
            
            appTitle.topAnchor.constraint(equalTo: myImageView.bottomAnchor),
            appTitle.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            appTitle.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    var bannerTouchesBegan: (()->()) = { }
    var bannerTouchesEnded: (()->()) = { }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bannerTouchesBegan()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        bannerTouchesEnded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myImageView.image = nil
    }
    
    private func loadImage(_ myApp: SearchResult) {
        guard let myAppImage = myApp.appImage else { return }
        guard let url = URL(string: myAppImage)  else { return }

        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                self.myImageView.image = UIImage()
                return
            }
            guard self.appStore?.appImage == url.absoluteString else { return }
            DispatchQueue.main.async {
                self.myImageView.image = UIImage(data: data)
            }
        }
    }
}
