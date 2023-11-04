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

    private enum CodingKeys: CodingKey {
        case petProfile
        case petName
        case petAge
        case petType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.petProfile = try container.decode(String.self, forKey: .petProfile)
        self.petName = try container.decode(String.self, forKey: .petName)
        self.petAge = try container.decode(Int.self, forKey: .petAge)
        self.petType = try container.decode(String.self, forKey: .petType)
    }
}
