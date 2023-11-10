import Foundation

// 사용자 정보
struct PetData: Codable {
    let photo: String
    let name: String
    let age: Int
    let spices: String
    
    init(photo: String, name: String, age: Int, spices: String) {
        self.photo = photo
        self.name = name
        self.age = age
        self.spices = spices
    }
    
    private enum CodingKeys: CodingKey {
        case photo
        case name
        case age
        case spices
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photo = try container.decode(String.self, forKey: .photo)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.spices = try container.decode(String.self, forKey: .spices)
    }
}
