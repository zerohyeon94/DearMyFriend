//
//  NaverGeocoding.swift
//  DearMyFriend
//
//  Created by 김기현 on 2023/10/26.
//

import Foundation
import Moya

enum NaverGeocodingService {
    case geocode(query: String)
}

extension NaverGeocodingService: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com/v1/map/geocode")!
    }

    var path: String {
        switch self {
        case .geocode:
            return ""
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .geocode(let query):
            return .requestParameters(parameters: ["query": query], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        // 네이버 API 키를 요청 헤더에 추가
        return ["X-Naver-Client-Id": "XD7ktQI1SXoyXYwBJkoq","X-Naver-Client-Secret": "NsKbaGjMm9"]

    }
}
