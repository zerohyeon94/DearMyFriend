//
//  MapViewBoundsManager.swift
//  DearMyFriend
//
//  Created by 김기현 on 2023/11/14.
//

import FirebaseFirestore
import CoreLocation

class FirestoreManager {
    static let shared = FirestoreManager()

    private let db = Firestore.firestore()
    private let markersCollection = Firestore.firestore().collection("24시간동물병원2")

    func fetchDataInVisibleArea(center: CLLocationCoordinate2D, zoomLevel: Double, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
        let radius = calculateRadius(zoomLevel: zoomLevel)
        let northEast = calculateCoordinate(from: center, distance: radius, bearing: 45.0)
        let southWest = calculateCoordinate(from: center, distance: radius, bearing: 225.0)

        let query = markersCollection
            .whereField("latitude", isGreaterThan: southWest.latitude)
            .whereField("latitude", isLessThan: northEast.latitude)
            .whereField("longitude", isGreaterThan: southWest.longitude)
            .whereField("longitude", isLessThan: northEast.longitude)

        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("문서 가져오기 오류: \(error?.localizedDescription ?? "")")
                return
            }
            completion(documents)
        }
    }

    private func calculateCoordinate(from center: CLLocationCoordinate2D, distance: Double, bearing: Double) -> CLLocationCoordinate2D {
        let radiusEarth = 6371.0

        let deltaLat = distance / radiusEarth * (180.0 / Double.pi)
        let deltaLon = distance / (radiusEarth * cos(center.latitude * Double.pi / 180.0)) * (180.0 / Double.pi)

        let lat = center.latitude + deltaLat
        let lon = center.longitude + deltaLon

        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    private func calculateRadius(zoomLevel: Double) -> Double {
        let baseRadius = 1000.0
        let adjustedRadius = baseRadius * pow(2.0, 10 - zoomLevel)
        return adjustedRadius
    }
}
