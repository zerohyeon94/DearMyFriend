
import Foundation

enum 고양이상태 {
    case Select
    case 생후4개월미만
    case 생후4에서6개월
    case 생후7에서12개월
    case 일반성묘
    case 중성화된성묘
    case 활동량많은고양이
    case 노묘
    case 비만고양이
    
    var 가중치: Double {
        switch self {
        case .Select:
            return 0
        case .생후4개월미만:
            return 3.0
        case .생후4에서6개월:
            return 2.5
        case .생후7에서12개월:
            return 2.0
        case .일반성묘:
            return 1.4
        case .중성화된성묘:
            return 1.2
        case .활동량많은고양이:
            return 1.6
        case .노묘:
            return 0.7
        case .비만고양이:
            return 0.8
        }
    }
}
