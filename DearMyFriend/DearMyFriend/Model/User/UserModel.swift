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
    let nickname: String
    let petProfile: [String]
    let petName: [String]
    let petAge: [Int]
    let petType: [String]
    
    init(profile: String, id: String, nickname: String, petProfile: [String], petName: [String], petAge: [Int], petType: [String]) {
        self.profile = profile
        self.id = id
        self.nickname = nickname
        self.petProfile = petProfile
        self.petName = petName
        self.petAge = petAge
        self.petType = petType
    }
    
    private enum CodingKeys: CodingKey {
        case profile
        case id
        case nickname
        case petProfile
        case petName
        case petAge
        case petType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.profile = try container.decode(String.self, forKey: .profile)
        self.id = try container.decode(String.self, forKey: .id)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.petProfile = try container.decode([String].self, forKey: .petProfile)
        self.petName = try container.decode([String].self, forKey: .petName)
        self.petAge = try container.decode([Int].self, forKey: .petAge)
        self.petType = try container.decode([String].self, forKey: .petType)
    }
}

// 사용자 정보
struct UserInfo: Codable {
    let agreement: String
    let email: String
    let username: String
    
    init(agreement: String, email: String, username: String) {
        self.agreement = agreement
        self.email = email
        self.username = username
    }
    
    private enum CodingKeys: CodingKey {
        case agreement
        case email
        case username
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.agreement = try container.decode(String.self, forKey: .agreement)
        self.email = try container.decode(String.self, forKey: .email)
        self.username = try container.decode(String.self, forKey: .username)
    }
}
