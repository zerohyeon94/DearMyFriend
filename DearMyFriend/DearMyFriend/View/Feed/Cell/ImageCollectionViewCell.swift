import Foundation
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    static let identifier = "ImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 이미지가 중복표시되던 부분 수정.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    private func setupUI() {
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
    
    func configureURL(imageURL: String) {
        let url = URL(string: imageURL) //입력받은 url string을 URL로 변경
        
        //main thread에서 load할 경우 URL 로딩이 길면 화면이 멈춘다.
        //이를 방지하기 위해 다른 thread에서 처리함.
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    //UI 변경 작업은 main thread에서 해야함.
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
}
