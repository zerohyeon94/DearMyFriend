import UIKit

struct Collection {
    // MARK: - MainWidthOfPadding
    static let mainWidthOfPadding = UIScreen.main.bounds.width-20
    
    // MARK: - Main Bounds
    static let bannerWidth = Int(UIScreen.main.bounds.width)
    static let bannerHeight = Int(bannerWidth/2)
    
    // MARK: - 컬렉션 뷰 식별자
    static let menuIdentifier = "mainCV"
    static let rankIdentifier = "rankCV"
    static let storeIdentifier = "storeCV"
    static let placeIdentifier = "placeCV"
    static let rankStoryIdentifier = "rankStoryCV"

    // MARK: - 메뉴 컬렉션 뷰
    static let menuSpacing: CGFloat = 20
    static let menuColumns: CGFloat = 4
    static let menuSize = Int((mainWidthOfPadding - (menuSpacing * menuColumns)) / Collection.menuColumns)+1
    static let cellHeightSize = Int((mainWidthOfPadding - (menuSpacing * menuColumns)) / Collection.menuColumns)+17
    
    // MARK: - 추천 컬렉션 뷰
    static let reuseSpacing: CGFloat = 20
    
    static let reuseStoreColumns: CGFloat = 3.5
    static let reuseStoreWidtSize = Int((mainWidthOfPadding - (reuseSpacing * reuseStoreColumns)) / Collection.reuseStoreColumns)
    static let reuseStoreHeightSize = Int((mainWidthOfPadding - (reuseSpacing * reuseStoreColumns)) / Collection.reuseStoreColumns)+17
    
    
    static let reusePlaceColumns: CGFloat = 2
    static let reusePlaceWidtSize = (reuseStoreWidtSize*2) + 20
    static let reusePlaceHeightSize:CGFloat = 100
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

enum ButtonConfig {
    static let cameraImageConfig = UIImage.SymbolConfiguration(pointSize: 2, weight: .light, scale: .small)
    static let cameraIcon = UIImage(systemName: "camera", withConfiguration: cameraImageConfig)
    
    static let checkIconConfig = UIImage.SymbolConfiguration(pointSize: 5, weight: .heavy, scale: .small)
    static let checkIcon = UIImage(systemName: "checkmark.square", withConfiguration: cameraImageConfig)
    static let checkFillIcon = UIImage(systemName: "checkmark.square.fill", withConfiguration: cameraImageConfig)
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
//                        UIImage(named: "banner_01"),
//                        UIImage(named: "banner_02"),
//                        UIImage(named: "banner_01")
                        ]
    
    static var testImage = ["one",
                        "two",
                        "three",
                        "four",
                        "five"]
}

struct ThemeColor {
    static let textColor = UIColor.init(hexCode: "f4f4f4")
    static let deepTextColor = UIColor.init(hexCode: "212529") // 515151
    
    static let titleColor = UIColor.init(hexCode: "282828")
    
    static let borderLineColor = UIColor.init(hexCode: "e9ecef")
    
    static let deepPink = UIColor.init(hexCode: "ff628f") //ff628f
    static let pink = UIColor.init(hexCode: "FFE6ED") // FFE6ED
}

struct textSize {
    static let checkText = UIFont(name: "SpoqaHanSansNeo-Medium", size: 13) ?? .systemFont(ofSize: 13)
    static let agreementText = UIFont(name: "SpoqaHanSansNeo-Medium", size: 15) ??
        .systemFont(ofSize: 15)

}
