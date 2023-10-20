import UIKit

struct Collection {
    static let identifiet = "mainCV"
    static let spacingWitdh: CGFloat = 5
    static let cellColumns: CGFloat = 4
    
    static let itemSize = ((UIScreen.main.bounds.width-80) - Collection.spacingWitdh * (Collection.cellColumns - 1)) / Collection.cellColumns
}

enum ButtonIcon {
    static let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .small)
    static let playIcon = UIImage(systemName: "play.rectangle", withConfiguration: imageConfig)
    static let mapIcon = UIImage(systemName: "map.fill", withConfiguration: imageConfig)
    static let wishIcon = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
    static let foodIcon = UIImage(systemName: "fork.knife", withConfiguration: imageConfig)
 
    static let allButton = [playIcon, mapIcon, wishIcon, foodIcon]
}

enum Menu: CaseIterable {
    static let youtube = "참고 영상"
    static let hospital = "주변 병원"
    static let wishList = "저장리스트"
    static let calculate = "급여량"
}

struct MenuTest {
    static let youtube: [String:UIImage?] = ["참고영상":UIImage(named: "youtube")]
    static let hospital: [String:UIImage?] = ["주변병원":UIImage(named: "map")]
    static let wishList: [String:UIImage?] = ["저장리스트":UIImage(named: "wish")]
    static let calculate: [String:UIImage?] = ["급여량계산기":UIImage(named: "calcul")]
    
    static let allMenu: [[String:UIImage?]] = [youtube,hospital,wishList,calculate]
}

