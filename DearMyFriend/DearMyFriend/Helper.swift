import UIKit

struct Collection {
    static let menuIdentifier = "mainCV"
    static let rankIdentifier = "rankeCV"
    static let storeIdentifier = "storeCV"
    static let placeIdentifier = "placeCV"
    
    static let menuColumns: CGFloat = 4
    static let menuSize = ((UIScreen.main.bounds.width-40) / Collection.menuColumns)
    
    static let reuseSpacing: CGFloat = 10
    static let reuseStoreColumns: CGFloat = 2.5
    static let reuseStoreWidtSize = ((UIScreen.main.bounds.width-40) / Collection.reuseStoreColumns)
    static let reuseStoreHeightSize:CGFloat = 100
    
    static let reusePlaceColumns: CGFloat = 2
    static let reusePlaceWidtSize = ((UIScreen.main.bounds.width-40) / Collection.reusePlaceColumns)
    static let reusePlaceHeightSize:CGFloat = 150
}

struct AppstoreSearchUrl {
    static let url = "https://itunes.apple.com/search?media=software&country=kr&limit=5"
}

enum ButtonIcon {
    static let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .small)
    static let playIcon = UIImage(systemName: "play.rectangle", withConfiguration: imageConfig)
    static let mapIcon = UIImage(systemName: "map.fill", withConfiguration: imageConfig)
    static let wishIcon = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
    static let foodIcon = UIImage(systemName: "fork.knife", withConfiguration: imageConfig)
 
    static let allButton = [playIcon, mapIcon, wishIcon, foodIcon]
}

struct MenuTest {
    static let youtube: [String:UIImage?] = ["참고영상":UIImage(named: "youtube")]
    static let hospital: [String:UIImage?] = ["주변병원":UIImage(named: "map")]
    static let wishList: [String:UIImage?] = ["저장리스트":UIImage(named: "wish")]
    static let calculate: [String:UIImage?] = ["급여량계산기":UIImage(named: "calcul")]
    
    static let allMenu: [[String:UIImage?]] = [youtube,hospital,wishList,calculate]
}

struct Rankbanner {
    static var image = [UIImage(named: "one"),
                        UIImage(named: "two"),
                        UIImage(named: "three"),
                        UIImage(named: "four"),
                        UIImage(named: "five")]
    static let imageNum = CGFloat(image.count)
}

