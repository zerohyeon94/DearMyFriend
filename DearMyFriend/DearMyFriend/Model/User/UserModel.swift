//
//  UserModel.swift
//  DearMyFriend
//
//  Created by t2023-m0059 on 2023/10/26.
//

import Foundation

// 사용자 정보
struct UserData: Codable {
    let profile: String
    let id: String
    let password: String
    let nickname: String
    let petName: [String]
    let petAge: [Int]
    let petType: [String]
    
    init(profile: String, id: String, password: String, nickname: String, petName: [String], petAge: [Int], petType: [String]) {
        self.profile = profile
        self.id = id
        self.password = password
        self.nickname = nickname
        self.petName = petName
        self.petAge = petAge
        self.petType = petType
    }
    
    private enum CodingKeys: CodingKey {
        case profile
        case id
        case password
        case nickname
        case petName
        case petAge
        case petType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.profile = try container.decode(String.self, forKey: .profile)
        self.id = try container.decode(String.self, forKey: .id)
        self.password = try container.decode(String.self, forKey: .password)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.petName = try container.decode([String].self, forKey: .petName)
        self.petAge = try container.decode([Int].self, forKey: .petAge)
        self.petType = try container.decode([String].self, forKey: .petType)
    }
}
