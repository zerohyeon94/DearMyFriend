import UIKit

struct CommentModel {
    var profileImage: UIImage?
    var userName: String?
    var comment: String?
    var uid: String?
    var imageUrl: String?
}

struct UserInfoModel {
    var profileImage: UIImage?
    var userName: String?
    var imageUrl: String?
}

struct ReportCommentModel {
    let uid: String
    var documentID: String
    var comment: String
    
    func toFirestoreData() -> [String: Any] {
        
        let data: [String: Any] = [
            "uid": uid,
            "documentID": documentID,
            "comment": comment
        ]
        
        return data
    }
}
