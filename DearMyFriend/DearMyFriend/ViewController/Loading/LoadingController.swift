import UIKit
import Lottie

class LoadingController: UIViewController {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loading")
        return view
    }()
    
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading")
        animation.loopMode = .loop
        return animation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.animationView.play()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.addSubviews([
            imageView,
            animationView
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            animationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant: -150),
            animationView.widthAnchor.constraint(equalToConstant: 50),
            animationView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }



}
