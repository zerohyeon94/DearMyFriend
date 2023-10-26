import Foundation

enum NetworkingError: Error {
    case dataError
    case networkError
    case parseError
}

class AppNetworking {
    
    static let shared = AppNetworking()
    
    private init() {}
    
    typealias Networkcompletion = (Result<[SearchResult], NetworkingError>) -> Void
    
    
    func fetchMusic(searchTerm: String, completionHandler: @escaping Networkcompletion) {
        // 문자열을 URL로 변환할 때 공백, 특수 문자, 한글 등이 URL에서 허용되지 않는 문자로 구성되어 있는 경우, URL로 변환할 수 없다.
        // addingPercentEncoding(withAllowedCharacters:) 사용해서 해결
        if let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            let urlString = "\(AppstoreSearchUrl.url)&term=\(encodedSearchTerm)"
            performRequest(with: urlString) { completionHandler($0) }
        } else {
            completionHandler(.failure(.networkError))
        }
    }
    
    func performRequest(with urlString: String, completionHandler: @escaping Networkcompletion) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, url, error in
            
            if error != nil {
                print(error!)
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let safeData = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과를 받음
            if let apps = self.parseJSON(safeData) {
                completionHandler(.success(apps))
            } else {
                completionHandler(.failure(.parseError))
            }
        }.resume()
    }
    
    func parseJSON(_ searchData: Data) -> [SearchResult]? {
        do {
            // 우리가 만들어 놓은 구조체(클래스 등)로 변환하는 객체와 메서드
            // (JSON 데이터 ====> MusicData 구조체)
            let searchResult = try JSONDecoder().decode(RecommendationStore.self, from: searchData)
            return searchResult.results
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
