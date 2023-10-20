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
}
