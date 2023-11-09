import UIKit
import Firebase
import FirebaseDatabase

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

class RecommendationPlaceService {
    
    public static let shared = RecommendationPlaceService()
    private init() {}
    
    typealias Networkcompletion = (Result<[RecommendationPlace], NetworkError>) -> Void
    
    private var allPlace: [RecommendationPlace] = []
    
    let dataBase = Firestore.firestore().collection("RecommendationPlace")
    
    public func uploadPlace(completion: @escaping Networkcompletion) {
        dataBase.getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return }
            if error != nil {
                completion(.failure(.networkingError))
                return
            }
            
            
            guard let allList = querySnapshot else {
                completion(.failure(.dataError))
                return
            }
            
            for place in allList.documents {
                if let imageUrl = place["imageUrl"] as? String,
                   let pageUrl = place["pageUrl"] as? String,
                   let placeName = place["placeName"] as? String {
                    let petPlace = RecommendationPlace(imageUrl: imageUrl, pageUrl: pageUrl, placeName: placeName)
                    allPlace.append(petPlace)
                }
            }
            completion(.success(self.allPlace))
        }
    }
}
