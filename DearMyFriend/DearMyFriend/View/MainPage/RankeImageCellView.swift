import UIKit

class RankImageCellView: UICollectionViewCell {
    
    var bannerImage: String? {
        didSet {
            guard let bannerImage = bannerImage else { return }
            loadImage(bannerImage)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(myImageView)
        
        
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            myImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

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
    
    private func loadImage(_ url: String?) {
        guard let imageUrl = url else { return }
        guard let url = URL(string: imageUrl)  else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                self.myImageView.image = UIImage()
                return
            }
            DispatchQueue.main.async {
                self.myImageView.image = UIImage(data: data)
            }
        }
    }
}
