//
//  SearchAPIManager.swift
//  DearMyFriend
//
//  Created by 김기현 on 2023/10/16.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
//     let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let category, description, telephone, address: String
    let roadAddress, mapx, mapy: String

    func cleanTitle() -> String {
        return title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
