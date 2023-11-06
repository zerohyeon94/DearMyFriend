import UIKit

class SignButton: UIButton {
    
    private var colorBool = false
    
    enum FontSize {
        case big
        case complete
        case med
        case small
        case thin
    }
    
    init(title: String, hasBackground: Bool = false, fontSize: FontSize) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.backgroundColor = hasBackground ? ThemeColor.pink : .clear
        
        let titleColor: UIColor = hasBackground ? .white : .systemBlue
        self.setTitleColor(titleColor, for: .normal)
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        case .complete:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
            self.isEnabled = false
        case .med:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
            
        case .small:
            self.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
            
        case .thin:
            self.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            self.setTitleColor(.systemGray, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func validTrueColor() {
        if !colorBool {
            self.backgroundColor = ThemeColor.deepPink
            colorBool.toggle()
        }
    }
    
    public func validFalseColor() {
        if colorBool {
            self.backgroundColor = ThemeColor.pink
            colorBool.toggle()
        }
    }
}
