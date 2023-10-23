import UIKit

class RankImageCellView: UICollectionViewCell {
    
    let myImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.contentMode = .scaleToFill
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
            myImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    var bannerTouchesBegan: (()->()) = { }
    var bannerTouchesEnded: (()->()) = { }
    
    // 터치 이벤트 처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bannerTouchesBegan()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        bannerTouchesEnded()
    }
}
