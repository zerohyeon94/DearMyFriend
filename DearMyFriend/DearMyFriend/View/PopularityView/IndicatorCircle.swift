import UIKit

class IndicatorCircle: UIView {
    
    var startPoint: CGFloat = 0
    var remainingTime: TimeInterval = IndicatorInfo.duration
    
    let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let indicatorLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        self.indicatorLayer.frame = self.indicatorView.bounds
        
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(3 * Double.pi / 2)
        
        let backViewCenterPoint = CGPoint(x: self.backgroundView.bounds.width / 2, y: self.backgroundView.bounds.height / 2)
        let backViewPath = UIBezierPath(arcCenter: backViewCenterPoint,
                                        radius: self.backgroundView.bounds.height/2,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
        
        self.backgroundLayer.path = backViewPath.cgPath
        backgroundLayer.lineWidth = 2
        
        let indicatorCenterPoint = CGPoint(x: self.indicatorView.bounds.width / 2, y: self.indicatorView.bounds.height / 2)
        let circularPath = UIBezierPath(arcCenter: indicatorCenterPoint,
                                        radius: self.indicatorView.bounds.height/2,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
        
        self.indicatorLayer.path = circularPath.cgPath
        indicatorLayer.lineWidth = self.indicatorView.bounds.height
    }
    
    private func loadLayers() {
        self.backgroundView.layer.addSublayer(self.backgroundLayer)
        self.indicatorView.layer.addSublayer(self.indicatorLayer)
    }
    
    func animateForegroundLayer() {
        let startAnimation = CABasicAnimation(keyPath: "strokeEnd")
        startAnimation.fromValue = startPoint
        startAnimation.toValue = 1
        startAnimation.duration = remainingTime
        startAnimation.fillMode = .forwards
        startAnimation.isRemovedOnCompletion = false
        startAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        indicatorLayer.add(startAnimation, forKey: "strokeEnd")
    }
    
    func autoLayout() {
        self.backgroundView.layer.addSublayer(self.backgroundLayer)
        self.indicatorView.layer.addSublayer(self.indicatorLayer)
        addSubview(backgroundView)
        addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: IndicatorInfo.size-2),
            backgroundView.heightAnchor.constraint(equalToConstant: IndicatorInfo.size-2),
            
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: IndicatorInfo.size/2),
            indicatorView.heightAnchor.constraint(equalToConstant: IndicatorInfo.size/2)
        ])
    }
    
    func resetTime() {
        startPoint = 0
        remainingTime = IndicatorInfo.duration
        self.indicatorLayer.removeAllAnimations()
        animateForegroundLayer()
    }
}
