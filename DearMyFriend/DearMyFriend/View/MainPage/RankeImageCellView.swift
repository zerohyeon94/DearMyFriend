import UIKit

class RankImageCellView: UICollectionViewCell {
    
    var bannerImage: String? {
        didSet {
            guard let bannerImage = bannerImage else { return }
            loadImage(bannerImage) {}
        }
    }
    
    var placeData: RecommendationPlace? {
        didSet {
            guard let placeData = placeData else { return }
            loadImage(placeData.imageUrl) { [weak self] in
                guard let self = self else { return}
                self.placeName.text = placeData.placeName
            }
            
        }
    }
    
    let myImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor.pink
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let placeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 15)
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(activityIndicator)
        self.contentView.addSubview(placeName)
        
        
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            myImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            placeName.centerXAnchor.constraint(equalTo: self.myImageView.centerXAnchor),
            placeName.centerYAnchor.constraint(equalTo: self.myImageView.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.myImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.myImageView.centerYAnchor),
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
    
    private func loadImage(_ url: String?, completion: @escaping () -> ()) {
        guard let imageUrl = url else { return }
        guard let url = URL(string: imageUrl)  else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                self.myImageView.image = UIImage()
                return
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.myImageView.image = UIImage(data: data)
                completion()
            }
        }
    }
    
    override func prepareForReuse() {
        self.myImageView.image = nil
        self.placeName.text = nil
    }
}
