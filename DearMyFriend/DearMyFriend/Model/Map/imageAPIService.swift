//
//  ImageAPIManager.swift
//  DearMyFriend
//
//  Created by 김기현 on 2023/11/03.
//

import Foundation

//// MARK: - Welcome
struct ImageWelcome: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [ImageItem]
}

// MARK: - Item
struct ImageItem: Codable {
    let title: String
    let link: String
    let thumbnail: String
    let sizeheight, sizewidth: String
}
