////
////  NaverGeoCodingService.swift
////  DearMyFriend
////
////  Created by 김기현 on 2023/10/26.
////
//
//import Foundation
//import Moya
//
//class NaverGeocodingManager {
//    static let shared = NaverGeocodingManager()
//    private let provider = MoyaProvider<NaverGeocodingService>()
//
//    func geocodeAddress(_ address: String, completion: @escaping (GeocodingResult?, Error?) -> Void) {
//        provider.request(.geocode(query: address)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let geocodingResult = try JSONDecoder().decode(GeocodingResult.self, from: response.data)
//                    completion(geocodingResult, nil)
//                } catch {
//                    completion(nil, error)
//                }
//
//            case .failure(let error):
//                completion(nil, error)
//            }
//        }
//    }
//}
