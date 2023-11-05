import UIKit

struct Collection {
    // MARK: - MainWidthOfPadding
    static let mainWidthOfPadding = UIScreen.main.bounds.width-40
    
    // MARK: - Main Bounds
    static let bannerWidth = Int(UIScreen.main.bounds.width)
    static let bannerHeight = Int(bannerWidth/3)
    
    // MARK: - 컬렉션 뷰 식별자
    static let menuIdentifier = "mainCV"
    static let rankIdentifier = "rankCV"
    static let storeIdentifier = "storeCV"
    static let placeIdentifier = "placeCV"
    static let rankStoryIdentifier = "rankStoryCV"

    // MARK: - 메뉴 컬렉션 뷰
    static let menuSpacing: CGFloat = 25
    static let menuColumns: CGFloat = 4
    static let menuSize = ((mainWidthOfPadding - (menuSpacing * (menuColumns-1))) / Collection.menuColumns)
    static let cellHeightSize = ((mainWidthOfPadding - (menuSpacing * (menuColumns-1))) / Collection.menuColumns)+20
    
    // MARK: - 추천 컬렉션 뷰
    static let reuseSpacing: CGFloat = 10
    
    static let reuseStoreColumns: CGFloat = 2.5
    static let reuseStoreWidtSize = (mainWidthOfPadding / Collection.reuseStoreColumns)
    static let reuseStoreHeightSize:CGFloat = (mainWidthOfPadding / Collection.reuseStoreColumns)
    
    
    static let reusePlaceColumns: CGFloat = 2
    static let reusePlaceWidtSize = (mainWidthOfPadding / Collection.reusePlaceColumns)
    static let reusePlaceHeightSize:CGFloat = 150
}

struct IndicatorInfo {
    static let size: CGFloat = 35
    static let duration: CFTimeInterval = 5
}

struct PopularityTouch {
    static var touch: Bool = false
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
    static var image = [UIImage(named: "banner_01"),
                        UIImage(named: "banner_02"),
                        UIImage(named: "banner_03"),
                        UIImage(named: "four"),
                        UIImage(named: "five")]
    
    static var testImage = ["one",
                        "two",
                        "three",
                        "four",
                        "five"]
}

struct ThemeColor {
    static let textColor = UIColor.init(hexCode: "6c757d")
    static let deepTextColor = UIColor.init(hexCode: "212529")
    
    static let borderLineColor = UIColor.init(hexCode: "e9ecef")
    
    static let deepPink = UIColor.init(hexCode: "fb6f92")
    static let pink = UIColor.init(hexCode: "ffc2d1")
}

