import Foundation
import UIKit

class MyPostCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyPostCollectionViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraint()
    }
    
    private func setUI() {
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: topAnchor),
            postImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setPostImageView(with image: String) {
        if image == "image upload fail"{
            
        } else {
            configureURL(imageURL: image)
        }
    }
    
    func configureURL(imageURL: String) {
        let url = URL(string: imageURL) //입력받은 url string을 URL로 변경

        //main thread에서 load할 경우 URL 로딩이 길면 화면이 멈춘다.
        //이를 방지하기 위해 다른 thread에서 처리함.
        DispatchQueue.global().async { [weak self] in
            if imageURL == url?.absoluteString { // absoluteString을 사용하여 URL을 비교하여 로딩 중에 변경되었는지 확인.
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        //UI 변경 작업은 main thread에서 해야함.
                        DispatchQueue.main.async {
                            self?.postImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
