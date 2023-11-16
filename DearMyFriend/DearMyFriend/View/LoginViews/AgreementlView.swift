import UIKit

class AgreementView: UIView {
    
    public var allCheckBool = false 

    private let agreementlabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor.titleColor
        label.textAlignment = .left
        label.font = UIFont(name: "SpoqaHanSansNeo-Bold", size: 20)
        label.text = "내새꾸가이드\n서비스 이용약관"
        label.numberOfLines = 2
        return label
    }()
    
    public let checkAll = CheckPasswordView("모두 동의", textSize.agreementText)
    public let checkAge = CheckPasswordView("만 14세 이상입니다. (필수)", textSize.agreementText)
    public let checkServiceAgreement = CheckPasswordView("서비스 이용약관에 동의 (필수)", textSize.agreementText)
    public let checkInformation = CheckPasswordView("개인정보 수집 및 이용에 동의 (필수)", textSize.agreementText)
    
    public let serviceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13)
        button.setTitle("보기", for: .normal)
        return button
    }()
    
    public let informationButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13)
        button.setTitle("보기", for: .normal)
        return button
    }()
    
    public let signInButton = SignButton(title: "회원가입", hasBackground: true, fontSize: .complete)
    
    private let borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor.borderLineColor
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubviews([
            agreementlabel,
            checkAll,
            borderView,
            checkAge,
            checkServiceAgreement,
            checkInformation,
            signInButton,
            activityIndicator,
            serviceButton,
            informationButton
        ])
        
        NSLayoutConstraint.activate([
            agreementlabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            agreementlabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            checkAll.topAnchor.constraint(equalTo: self.agreementlabel.bottomAnchor, constant: 10),
            checkAll.leadingAnchor.constraint(equalTo: self.agreementlabel.leadingAnchor),
            checkAll.heightAnchor.constraint(equalToConstant: 55),
            
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            borderView.topAnchor.constraint(equalTo: checkAll.bottomAnchor, constant: 10),
            borderView.heightAnchor.constraint(equalToConstant: 1),
            
            checkAge.topAnchor.constraint(equalTo: self.borderView.bottomAnchor, constant: 10),
            checkAge.leadingAnchor.constraint(equalTo: self.agreementlabel.leadingAnchor),
            checkAge.heightAnchor.constraint(equalToConstant: 55),
            
            checkServiceAgreement.topAnchor.constraint(equalTo: self.checkAge.bottomAnchor, constant: 10),
            checkServiceAgreement.leadingAnchor.constraint(equalTo: self.agreementlabel.leadingAnchor),
            checkServiceAgreement.heightAnchor.constraint(equalToConstant: 55),
            
            serviceButton.topAnchor.constraint(equalTo: self.checkServiceAgreement.topAnchor),
            serviceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            serviceButton.heightAnchor.constraint(equalToConstant: 55),
            
            checkInformation.topAnchor.constraint(equalTo: self.checkServiceAgreement.bottomAnchor, constant: 10),
            checkInformation.leadingAnchor.constraint(equalTo: self.agreementlabel.leadingAnchor),
            checkInformation.heightAnchor.constraint(equalToConstant: 55),
            
            informationButton.topAnchor.constraint(equalTo: self.checkInformation.topAnchor),
            informationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            informationButton.heightAnchor.constraint(equalToConstant: 55),

            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    public func allCheck() {
        let checkList = [checkAll, checkAge, checkServiceAgreement, checkInformation]
        
        checkList.forEach {
            $0.colorBool = allCheckBool
            $0.changeColor()
        }
        
        self.allCheckBool.toggle()
    }
}
