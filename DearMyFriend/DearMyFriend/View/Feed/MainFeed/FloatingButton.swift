import UIKit

class FloatingButton: UIButton {
    
    enum ButtonType {
        case basic
        case write
    }

    init(imageName: String, type: ButtonType) {
        super.init(frame: .zero)
        
        if type == .write {
            self.alpha = 0.0
        }
        
        self.configuration = setupConfig(imageName)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfig(_ imageName: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = ThemeColor.deepPink
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        return config
    }
    
    private func setupLayer() {
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.3
    }
    
}
