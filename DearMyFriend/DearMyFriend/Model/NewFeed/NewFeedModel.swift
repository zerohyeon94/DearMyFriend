import UIKit

struct NewFeedModel {
    var uid: String?
    var image: [String]?
    var post: String?
    var documentID: String?
    var profileImageUrl: String?
    var userName: String?
    var profileImage: UIImage?
    var reportCount: Int?
    var likeBool = false
    var likeCount: Int?
    var feedImages: [Int:UIImage] = [:]
    // 옵셔널 배열에 데이터를 추가하게되면 추가가 안되는 버그 발생
    // 그래서 빈배열로 만들어줌
}
