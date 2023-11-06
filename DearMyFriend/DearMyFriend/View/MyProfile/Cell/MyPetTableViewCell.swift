import Foundation
import UIKit

class MyPetTableViewCell: UITableViewCell {
    // MARK: Properties
    static let identifier = "MyPetTableViewCell"
    
    var cellIndex: Int = 0
    let sideSpaceConstant: CGFloat = 16
    
    // MARK: Properties
    // ImageView
    let profileImageFrame: CGFloat = 100
    // Label
    let profileTitleLabelSize: CGFloat = 18
    let profileSubTitleLabelSize: CGFloat = 15
    
    lazy var petProfileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: profileImageFrame, height: profileImageFrame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "spider1")
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = profileImageFrame / 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        
        return imageView
    }()
    
    lazy var petNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: profileTitleLabelSize)
        label.text = ""
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var petAgeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: profileSubTitleLabelSize)
        label.text = ""
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var petTypeLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SpoqaHanSansNeo-Regular", size: profileSubTitleLabelSize)
        label.text = ""
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var petInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [petNameLabel, petAgeLabel, petTypeLabel])
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
    }()
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//        self.contentView.backgroundColor = .yellow
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }
    
    // MARK: Configure
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI(){
        [petProfileImageView, petInfoStackView].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setProfileImageConstraint()
        setProfileStackViewConstraint()
    }
    
    // MARK: - Constant
    // Profile Image
    let profileHeight: CGFloat = 100
    let profileWidth: CGFloat = 100
    
    private func setProfileImageConstraint() {
        NSLayoutConstraint.activate([
            petProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            petProfileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            petProfileImageView.heightAnchor.constraint(equalToConstant: profileHeight),
            petProfileImageView.widthAnchor.constraint(equalToConstant: profileWidth),
        ])
    }
    
    private func setProfileStackViewConstraint() {
        NSLayoutConstraint.activate([
            petInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            petInfoStackView.leadingAnchor.constraint(equalTo: petProfileImageView.trailingAnchor, constant: 20),
        ])
    }
    
    func setPetInfo(petData: PetData, index: Int){
        configureURL(imageURL: petData.petProfile)
        petNameLabel.text = petData.petName
        petAgeLabel.text = "\(petData.petAge) 살"
        petTypeLabel.text = petData.petType
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
                            self?.petProfileImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
