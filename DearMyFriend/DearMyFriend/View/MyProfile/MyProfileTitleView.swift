import Foundation
import UIKit

protocol MyProfileTitleViewDelegate: AnyObject {
    func settingButtonTapped()
}

class MyProfileTitleView: UIView {
    
    // MARK: Properties
    let titleLabelSize: CGFloat = 20
    let buttonSize: CGFloat = 30
    let buttonImage: String = "gearshape"
    let buttonColor: UIColor = .black
    
    weak var delegate: MyProfileTitleViewDelegate?
    
    lazy var myPageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: titleLabelSize)
        label.text = "Me & My Friend"
        label.textAlignment = .center
        return label
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: buttonSize, weight: .light)
        let image = UIImage(systemName: buttonImage, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = buttonColor
        
        button.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    

        

        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setUI()
        setConstraint()
    }
    
    private func setUI(){
        [myPageTitleLabel, settingButton].forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConstraint() {
        setNicknameLabelConstraint()
        setAddPostButtonConstraint()
    }
    
    private func setNicknameLabelConstraint() {
        NSLayoutConstraint.activate([
            myPageTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            myPageTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            myPageTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            myPageTitleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setAddPostButtonConstraint() {
        NSLayoutConstraint.activate([
            settingButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            settingButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            settingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func settingButtonTapped() {
        print("설정 창 실행")
        delegate?.settingButtonTapped()
    }
}
