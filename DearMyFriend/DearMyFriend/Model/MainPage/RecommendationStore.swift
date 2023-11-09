import Foundation

// MARK: - Welcome
struct RecommendationStore: Codable {
    let resultCount: Int
    let results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
}

// MARK: - Result
struct SearchResult: Codable {
    let appImage: String?
    let appUrl: String?
    let trackCensoredName: String?

    enum CodingKeys: String, CodingKey {
        case appImage = "artworkUrl512"
        case appUrl = "trackViewUrl" 
        case trackCensoredName
    }
    
    var appName: String? {
        guard let appName = trackCensoredName else { return ""}
        let components = appName.components(separatedBy: " ")
        if let firstComponent = components.first {
            return firstComponent
        }
        return trackCensoredName
    }
}
