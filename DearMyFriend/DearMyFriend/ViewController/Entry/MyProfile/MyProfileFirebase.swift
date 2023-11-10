import FirebaseFirestore
import FirebaseFirestoreSwift

final class MyProfileFirestore {
    
    let collectionUsers = "Users"
    let collectionFeeds = "Feeds"
    let collectionPet = "Pet"
    
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
    
    func getMyFeed(uid: String, completion: @escaping ([[String: FeedModel]]) -> Void) {
        var myFeedData: [[String: FeedModel]] = [] // key : Feed Document ID, value : 데이터
        
        // 'Users' collection & 해당되는 User ID
        let documentID: String = uid
        let collectionListener = Firestore.firestore().collection(collectionFeeds)
        print("1111 documentID: \(documentID)")
        collectionListener.whereField("uid", isEqualTo: documentID)
            .order(by: "date", descending: true)
            .getDocuments { (querySnapshot, error) in
//        collectionListener.whereField("uid", isEqualTo: documentID).getDocuments() { (querySnapshot, error) in
//        collectionListener.order(by: "date", descending: true).getDocuments() { (querySnapshot, error) in
            print("1111 querySnapshot: \(querySnapshot)")
            if let error = error {
                print("뭐지?")
                print("Error getting documents: \(error)")
            } else {
                print("1111 querySnapshot!.documents: \(querySnapshot!.documents)")
                for document in querySnapshot!.documents{
                    print("1111 documentID: \(documentID)")
                    // Firestore 문서의 데이터를 딕셔너리로 가져옴
                    var feedUid: String = ""
                    var feedDate: Date = Date()
                    var feedImageUrl: [String] = []
                    var feedPost: String = ""
                    var feedLike: [String] = []
                    var feedLikeCount: Int = 0
                    var feedComment: [[String: String]] = []
                    
                    let data = document.data()
                    print("data: \(data)")
                    if let uid = data["uid"] as? String {
                        feedUid = uid
                    }
                    
                    if let date = data["date"] as? Date {
                        feedDate = date
                    }
                    print("feedDate: \(feedDate)")
                    
                    if let imageUrl = data["imageUrl"] as? [String] {
                        feedImageUrl = imageUrl
                    }
                    
                    if let post = data["post"] as? String {
                        feedPost = post
                    }
                    
                    if let like = data["like"] as? [String] {
                        feedLike = like
                    }
                    
                    if let likeCount = data["likeCount"] as? Int {
                        feedLikeCount = likeCount
                    }
                    
                    if let comment = data["comment"] as? [[String: String]] {
                        feedComment = comment
                    }
                    
                    let feedData = FeedModel(uid: feedUid, date: feedDate, imageUrl: feedImageUrl, post: feedPost, like: feedLike, likeCount: feedLikeCount, comment: feedComment)
                    
                    // document ID를 key값으로 저장.
                    myFeedData.append([document.documentID : feedData])
                }
                completion(myFeedData)
            }
        }
    }
    
    func getMyPet(uid: String, completion: @escaping ([[String: RegisterMyPetInfo]]) -> Void) {
        var myPetData: [[String: RegisterMyPetInfo]] = [] // key : pet Document ID, value : 데이터
        // 'Users' collection & 해당되는 User ID
        let documentID: String = uid
        let collectionListener = Firestore.firestore().collection(collectionUsers).document(documentID).collection(collectionPet) // Users / Document ID / Pet
        
        // Pet 내에 있는 pet document ID 값 얻기
        collectionListener.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                for document in querySnapshot!.documents{
                    
                    // Firestore 문서의 데이터를 딕셔너리로 가져옴
                    var petAge: String = ""
                    var petName: String = ""
                    var petPhoto: String = ""
                    var petSpices: String = ""
                    
                    let data = document.data()
                    if let age = data["age"] as? String {
                        petAge = age
                    }
                    
                    if let name = data["name"] as? String {
                        petName = name
                    }
                    
                    if let photo = data["photo"] as? String {
                        petPhoto = photo
                    }
                    
                    if let spices = data["spices"] as? String {
                        petSpices = spices
                    }
                    
                    
                    let petData = RegisterMyPetInfo(name: petName, age: petAge, type: petSpices, photoUrl: petPhoto)
                    myPetData.append([document.documentID : petData])
                }
                
                completion(myPetData)
            }
        }
    }
}
