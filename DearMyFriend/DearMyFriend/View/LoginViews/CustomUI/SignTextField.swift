import UIKit

class SignTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case email
        case password
    }
        
    init(fieldType: CustomTextFieldType) {
        super.init(frame: .zero)
        
        self.backgroundColor = ThemeColor.textColor
        self.font = UIFont(name: "SpoqaHanSansNeo-Medium", size: 18)
        self.textColor = ThemeColor.titleColor
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            self.placeholder = "닉네임 (4~8글자)"
        case .email:
            self.placeholder = "이메일"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            
        case .password:
            self.placeholder = "비밀번호"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
