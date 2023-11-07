import FirebaseFirestore
import FirebaseFirestoreSwift

final class MyProfileFirestore {
    
    let collectionUsers = "Users"
    let collectionFeed = "Feed"
    
    // MARK: Read
    func getMyProfile(completion: @escaping (UserData) -> Void) { //} -> [[String: FeedData]] {
        var myProfile: UserData? // 데이터
        
        // 'Users' collection & 해당되는 User ID
        let documentID: String = "_zerohyeon"
        let collectionListener = Firestore.firestore().collection(collectionUsers).document(documentID)
        
        collectionListener.getDocument { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                var documentData: [String: Any] = [:]
                
                if let data = querySnapshot?.data() as? [String: Any] {
                    documentData = data
                }
                
                var userProfile: String = ""
                var userId: String = ""
                var userNickname: String = ""
                var userPetProfile: [String] = []
                var userPetName: [String] = []
                var userPetAge: [Int] = []
                var userPetType: [String] = []
                
                if let profile = documentData["profile"] as? String {
                    userProfile = profile
                }
                
                if let id = documentData["id"] as? String {
                    userId = id
                }
                
                if let nickname = documentData["nickname"] as? String {
                    userNickname = nickname
                }
                
                if let petProfile = documentData["petProfile"] as? [String] {
                    userPetProfile = petProfile
                }
                
                if let petName = documentData["petName"] as? [String] {
                    userPetName = petName
                }
                
                if let petAge = documentData["petAge"] as? [Int] {
                    userPetAge = petAge
                }
                
                if let petType = documentData["petType"] as? [String] {
                    userPetType = petType
                }
                print("userProfile: \(userProfile)")
                print("userId: \(userId)")
                print("userNickname: \(userNickname)")
                print("userPetProfile: \(userPetProfile)")
                print("userPetName: \(userPetName)")
                print("userPetAge: \(userPetAge)")
                print("userPetType: \(userPetType)")
                
                let userMyProfile = UserData(profile: userProfile, id: userId, nickname: userNickname, petProfile: userPetProfile, petName: userPetName, petAge: userPetAge, petType: userPetType)
                
                myProfile = userMyProfile
                
                completion(myProfile!) // 추후 옵셔널 바인딩해야함.
            }
        }
    }
    
    func getMyFeed(completion: @escaping ([[String: FeedData]]) -> Void) { //} -> [[String: FeedData]] {
        var myFeedData: [[String: FeedData]] = [] // key : 업로드 날짜, value : 데이터
        
        // 'Users' collection & 해당되는 User ID
        let documentID: String = "_zerohyeon"
        let collectionListener = Firestore.firestore().collection(collectionUsers).document(documentID).collection(collectionFeed)
        
        collectionListener.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents{
                    
                    // Firestore 문서의 데이터를 딕셔너리로 가져옴
                    var userFeedId: String = ""
                    var userFeedImage: [String] = []
                    var userFeedPost: String = ""
                    var userFeedLike: [String] = []
                    var userFeedComment: [[String: String]] = []
                    
                    let data = document.data()
                    if let id = data["id"] as? String {
                        userFeedId = id
                    }
                    
                    if let image = data["image"] as? [String] {
                        userFeedImage = image
                    }
                    
                    if let post = data["post"] as? String {
                        userFeedPost = post
                    }
                    
                    if let like = data["like"] as? [String] {
                        userFeedLike = like
                    }
                    
                    if let comment = data["comment"] as? [[String: String]] {
                        userFeedComment = comment
                    }
                    
                    let userFeedData = FeedData(id: userFeedId, image: userFeedImage, post: userFeedPost, like: userFeedLike, comment: userFeedComment)
                    myFeedData.append([document.documentID : userFeedData])
                }
                
                completion(myFeedData)
            }
        }
    }
    
}
