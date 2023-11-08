//
//  NaverSearchService.swift
//  DearMyFriend
//
//  Created by 김기현 on 2023/10/13.
//

import Foundation
import Moya

enum NaverSearchService {
    case search(query: String, categories: [String] = [])
    case searchImage(query: String)
}

extension NaverSearchService: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com/v1/search")!
    }

    var path: String {
        switch self {
        case .search:
            return "/local.json"
        case .searchImage:
            return "/image"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .search(let query, let categories):
            return .requestParameters(parameters: ["query": query, "categories": categories, "display": 10], encoding: URLEncoding.default)
        case .searchImage(let query):  // 이미지 검색 요청 파라미터 설정
            return .requestParameters(parameters: ["query": query, "display": 1], encoding: URLEncoding.default)
        }
    }


    var headers: [String: String]? {
        return ["X-Naver-Client-Id": "XD7ktQI1SXoyXYwBJkoq","X-Naver-Client-Secret": "NsKbaGjMm9"]
    }
}
