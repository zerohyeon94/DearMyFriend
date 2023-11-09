import Foundation

// 사용자 정보
struct PetData: Codable {
    let petProfile: String
    let petName: String
    let petAge: Int
    let petType: String
    
    init(petProfile: String, petName: String, petAge: Int, petType: String) {
        self.petProfile = petProfile
        self.petName = petName
        self.petAge = petAge
        self.petType = petType
    }
}
