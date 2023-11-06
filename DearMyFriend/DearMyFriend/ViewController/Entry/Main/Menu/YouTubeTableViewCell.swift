// 박철우 - 유튜브 셀 페이지

import Foundation
import Lottie
import SnapKit
import UIKit
import SwiftUI
class YouTubeTableViewCell: UITableViewCell {
    
    var block = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.white
        uiView.layer.borderWidth = 5
        uiView.layer.borderColor = UIColor(named: "border")?.cgColor
        uiView.layer.cornerRadius = 10
        return uiView
    } ()
    var titleLabel = {
        let label = UILabel()
        label.text = ""
        return label
    } ()
    
    var youtubeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor(named: "border")?.cgColor
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var youtubeAnime: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "유튜브애니메이션")
        animationView.contentMode = .scaleAspectFit

        animationView.loopMode = .loop
        
        animationView.animationSpeed = 1

        animationView.play()
        return animationView
    }()
    
    var youtubeName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "maintext")
        return label
    }()
    
    var youtubeExplanation: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "subtext")
        label.numberOfLines = 0
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
       
        youtubeImage.image = nil
        youtubeName.text = nil
        youtubeExplanation.text = nil
    }
        
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(named: "cell")
        layer.borderColor = UIColor(named: "border")?.cgColor
        layer.borderWidth = 20
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 10
        
        addSubviews([block])
        addSubview(youtubeImage)
        addSubview(youtubeName)
        addSubview(youtubeExplanation)
        addSubview(youtubeAnime)
        
        
        block.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
        }
      
        youtubeImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(block)
            make.trailing.equalTo(block).offset(-250)
        }
        
        youtubeName.snp.makeConstraints { make in
            make.top.equalTo(block).offset(4)
            make.leading.equalTo(youtubeImage.snp.trailing).offset(14)
            make.trailing.equalTo(block).offset(-8)
        }
        
        youtubeExplanation.snp.makeConstraints { make in
            make.top.equalTo(youtubeName.snp.bottom).offset(5)
            make.bottom.equalTo(block)
            make.leading.equalTo(youtubeImage.snp.trailing).offset(14)
            make.trailing.equalTo(block).offset(-8)
        }
        
        youtubeAnime.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.top.equalTo(youtubeName.snp.top).offset(-5)
            make.bottom.equalTo(youtubeName.snp.bottom).offset(5)
            make.trailing.equalTo(block).offset(10)
        }
        
        selectionStyle = .none
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "youtubeCell")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//


