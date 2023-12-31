//
//  FeedModel.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/16.
//

import UIKit
import FirebaseFirestore


// 업로드 되는 피드 정보
struct FeedModel: Codable {
    let uid: String
    let date: Date
    let imageUrl: [String]
    var post: String
    var like: [String]
    var likeCount: Int
    var comment: [[String: String]]
    
    func toFirestoreData() -> [String: Any] {
        
         let timestamp = Timestamp(date: date)

         let imageUrlArray: [Any] = imageUrl
         let commentArray: [Any] = comment.map { $0 as Any }

         let data: [String: Any] = [
             "uid": uid,
             "date": timestamp,
             "imageUrl": imageUrlArray,
             "post": post,
             "likeCount": likeCount,
             "comment": commentArray
         ]

         return data
     }
    
    init(uid: String, date: Date, imageUrl: [String], post: String, like: [String], likeCount: Int, comment: [[String : String]]) {
        self.uid = uid
        self.date = date
        self.imageUrl = imageUrl
        self.post = post
        self.like = like
        self.likeCount = likeCount
        self.comment = comment
    }
    
    private enum CodingKeys: CodingKey {
        case uid
        case date
        case imageUrl
        case post
        case like
        case likeCount
        case comment
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.date = try container.decode(Date.self, forKey: .date)
        self.imageUrl = try container.decode([String].self, forKey: .imageUrl)
        self.post = try container.decode(String.self, forKey: .post)
        self.like = try container.decode([String].self, forKey: .like)
        self.likeCount = try container.decode(Int.self, forKey: .likeCount)
        self.comment = try container.decode([[String: String]].self, forKey: .comment)
    }
}

extension Encodable {
    var asDictionary: [String: Any]? { // 객체를 딕셔너리로 변환하는 메서드. 반환타입 [String: Any] 옵셔널
        guard let object = try? JSONEncoder().encode(self), // JSONEncoder를 사용하여 객체를 JSON 데이터로 인코딩
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { return nil } // JSONSerialization을 사용하여 JSON 데이터를 딕셔너리로 변환
        return dictinoary
    }
}
