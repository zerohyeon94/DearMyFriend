import UIKit
import NMapsMap
import CoreLocation
import Moya
import SnapKit
import Kingfisher


class MapViewController: UIViewController, NMFMapViewCameraDelegate, NMFMapViewDelegate {

    var isLoadingResults: Bool = false
    var searchStart: Int = 1
    var selectedItem: Item?
    var locationManager = CLLocationManager()
    var naverMapView: NMFNaverMapView?
    let geocoder = CLGeocoder()
    var searchResults: [(title: String, roadAddress: String)] = []
    let naverSearch = MoyaProvider<NaverSearchService>()
    let SearchResultCell = "SearchResultCell"
    var markers: [NMFMarker] = []
    var searchResultsTableView: UITableView = UITableView()
    var searchController: UISearchController!
    var searchResultsTableViewController: UITableViewController!
    var recentSearches: [String] = []
    var modalData: (title: String, roadAddress: String, telephone: String)?
    var searchRadius: CLLocationDistance = 1000

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        return imageView

    }()

    private lazy var showAnimalHospitalButton: UIButton = {
        let button = createStyledButton(title: "동물병원")
        button.addTarget(self, action: #selector(showAnimalHospital), for: .touchUpInside)
        return button
    }()


    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 10

        return button
    }()

    private lazy var locationNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private lazy var roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(toggleHeart), for: .touchUpInside)
        return button
    }()
    @objc func toggleHeart() {
        if heartButton.tintColor == .red {
            heartButton.tintColor = .gray
        } else {
            heartButton.tintColor = .red
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchResultCell)

        naverMapView = NMFNaverMapView(frame: self.view.frame)
        naverMapView?.showLocationButton = true
        naverMapView?.mapView.isScrollGestureEnabled = true
        naverMapView?.mapView.delegate = self

        if let naverMapView = naverMapView {
            self.view.addSubview(naverMapView)
        }

        setupButtonLayout()
        setupLocationManager()
        setupSearchController()
        addTableView()

    }

    private func createStyledButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }

    private func setupButtonLayout() {
        view.addSubview(showAnimalHospitalButton)
//        view.addSubview(showPetShopsButton)

        showAnimalHospitalButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }

        showAnimalHospitalButton.layer.cornerRadius = 10
    }

    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            let status = self.locationManager.authorizationStatus
            if status == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            } else if status == .authorizedWhenInUse || status == .authorizedAlways {
                DispatchQueue.main.async {
                    self.locationManager.startUpdatingLocation()
                }
            }
        } else {
            print("위치 서비스가 활성화되어 있지 않습니다.")
        }
    }

    func setupSearchController() {
        searchResultsTableViewController = UITableViewController(style: .plain)
        searchResultsTableViewController.tableView = searchResultsTableView
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self

        searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "찿으시는 매장을 입력하세요!"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }


    func addTableView() {
        searchResultsTableView.frame = view.bounds
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        view.addSubview(searchResultsTableView)
    }

    func handleSearchResults(_ results: [(title: String, roadAddress: String)]) {
        if searchStart == 1 {
                   searchResults = results
               } else {
                   searchResults.append(contentsOf: results)
               }

               isLoadingResults = false
               searchResultsTableView.reloadData()
           }



    @objc func showAnimalHospital() {
        if isLoadingResults {
                   return
               }

               searchResults.removeAll()
               searchStart += 1  // 다시 첫 번째 페이지부터 시작
               searchLocalPlaces("동물병원")

           }

    @objc func closeModal() {
        modalView.removeFromSuperview()
        selectedItem = nil
    }

    @objc func showHalfModal() {
        guard let data = modalData else { return }
        print(data)
        self.searchImage(query: data.title) { imageURL in
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    } else {
                        print("이미지 로드 실")
                    }
                }
            }
        }

        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 10
        self.view.addSubview(modalView)

        modalView.addSubview(imageView)
        //    modalView.addSubview(heartButton)

        imageView.snp.makeConstraints {
            $0.top.equalTo(modalView).offset(16)
            $0.leading.equalTo(modalView).offset(16)
            $0.trailing.equalTo(modalView).offset(-16)
            $0.height.equalTo(150)
        }

        locationNameLabel.text = data.title
        roadAddressLabel.text = data.roadAddress
        phoneNumberLabel.text = data.telephone

        modalView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(300)
        }
        modalView.addSubview(locationNameLabel)
        locationNameLabel.snp.makeConstraints {
            $0.top.equalTo(modalView).offset(16)
            $0.leading.equalTo(modalView).offset(16)
            $0.trailing.equalTo(modalView).offset(-16)
        }
        modalView.addSubview(roadAddressLabel)
        roadAddressLabel.snp.makeConstraints {
            $0.top.equalTo(locationNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(modalView).offset(16)
            $0.trailing.equalTo(modalView).offset(-16)
        }
        modalView.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(roadAddressLabel.snp.bottom).offset(16)
            $0.leading.equalTo(modalView).offset(16)
            $0.trailing.equalTo(modalView).offset(-16)
        }


        modalView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.bottom.equalTo(modalView).inset(100)
            $0.trailing.equalTo(modalView).offset(-16)
            $0.width.equalTo(150)
            $0.height.equalTo(30)
        }
        modalView.addSubview(heartButton)
        heartButton.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.trailing.equalTo(closeButton).offset(-220)
            $0.width.height.equalTo(30)
        }
    }


    func addMarker(at coordinate: CLLocationCoordinate2D, title: String) {
        guard let mapView = naverMapView?.mapView else {
            return
        }

        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        marker.mapView = mapView
        marker.captionText = title

        marker.touchHandler = { [weak self] overlay in
            if let marker = overlay as? NMFMarker {
                let selectedItem = self?.searchResults.first(where: { $0.title == marker.captionText })
//                self?.modalData = (title: selectedItem?.title ?? "", roadAddress: selectedItem?.roadAddress ?? "")
                self?.showHalfModal()
            }
            return true
        }

        markers.append(marker)
    }
}

// MARK: - CLLocationManagerDelegate Extension
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
                print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.addMarker(at: location.coordinate, title: "현재 위치입니다.")

            }
        }
    }

// MARK: - UISearchBarDelegate Extension
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if let searchText = searchBar.text {
            searchLocalPlaces(searchText)
        }
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count + recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: SearchResultCell)

        if indexPath.row < recentSearches.count {
            cell.textLabel?.text = recentSearches[indexPath.row]
        } else {
            let resultIndex = indexPath.row - recentSearches.count
            let resultItem = searchResults[resultIndex]
            cell.textLabel?.text = resultItem.title
            cell.detailTextLabel?.text = resultItem.roadAddress
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < recentSearches.count {
            let selectedSearch = recentSearches[indexPath.row]
            geocoder.geocodeAddressString(selectedSearch) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    self?.moveMapToLocation(location.coordinate)
                    self?.addMarker(at: location.coordinate, title: selectedSearch)
                }
            }
        } else {
            let resultIndex = indexPath.row - recentSearches.count
            let selectedResultItem = searchResults[resultIndex]

            geocoder.geocodeAddressString(selectedResultItem.roadAddress) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    self?.moveMapToLocation(location.coordinate)
                    self?.addMarker(at: location.coordinate, title: selectedResultItem.title)
                    self?.modalData = (title: selectedResultItem.title, roadAddress: selectedResultItem.roadAddress, telephone: "")
                    self?.showHalfModal()
                }
            }
        }
    }

    func moveMapToLocation(_ coordinate: CLLocationCoordinate2D) {
        print("Moving to coordinate: \(coordinate.latitude), \(coordinate.longitude)")

        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: coordinate))
        if let mapView = naverMapView?.mapView {
            mapView.moveCamera(cameraUpdate)
        }

        if !searchResults.isEmpty {
            searchResultsTableView.isHidden = true
        }
    }
    func geocodeAndAddMarker(for title: String, roadAddress: String) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(roadAddress) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                self?.addMarker(at: location.coordinate, title: title)
            }
        }
    }
}

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayedSearch(_:)), object: searchController)
        perform(#selector(delayedSearch(_:)), with: searchController, afterDelay: 0.2)
    }

    @objc func delayedSearch(_ searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchLocalPlaces(searchText)
        }
    }
}

extension MapViewController {
    func searchLocalPlaces(_ query: String) {
        if isLoadingResults {
            return
        }
        searchResults.removeAll()
        searchStart = 1


        isLoadingResults = true
        let pageSize = 10

        naverSearch.request(.search(query: query)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(Welcome.self, from: response.data)
                    var searchResultsWithAddresses: [(title: String, roadAddress: String, telephone: String)] = []

                    if let mapView = self?.naverMapView?.mapView {
                        for item in results.items {
                            let title = item.title
                            let phoneNumber = item.telephone
                            let roadAddress: String? = item.roadAddress

                            if let roadAddress = roadAddress {
                                print("Title: \(title), roadAddress: \(roadAddress), phoneNumber: \(phoneNumber)")
                                //                                self?.geocodeAndAddMarker(for: title, roadAddress: roadAddress)
                            } else {
                                let alertController = UIAlertController(title: "주소를 찾을 수 없습니다", message: "해당 장소의 주소 정보를 찾을 수 없습니다.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self?.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }

                    if let self = self {
                        let placeInfos = results.items.map { (title: $0.cleanTitle(), roadAddress: $0.roadAddress ?? "") }
                        self.handleSearchResults(placeInfos)
                    }

                    self?.searchStart += pageSize
                } catch {
                    print("JSON decoding error: \(error)")
                }
            case .failure(let error):
                print("Network request error: \(error)")
            }
            self?.isLoadingResults = false
        }
    }
//    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
//        if reason == NMFMapChangedByGesture { // 사용자 제스처에 의해 지도가 이동된 경우
//            let cameraPosition = mapView.cameraPosition
//            let coordinates = cameraPosition.target
//
//            // 동물병원 검색
//            let query = "동물병원"
//            let places: [Place] = searchLocalPlaces(query)
//
//            // 검색 결과 돌면서
//            for place in places {
//                let distance = distance(coordinates, place.coordinate)
//                if distance <= 1000 { // 일정 반경 내에 있는 경우
//                    // 마커 추가
//                    addMarker(at: place.coordinate, title: place.title)
//                }
//            }
//        }
//    }

}
extension MapViewController {
    func searchImage(query: String, completion: @escaping (String?) -> Void) {
        print("searchImage 함수가 호출되었습니다. query: \(query)")
        naverSearch.request(.searchImage(query: query)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(ImageWelcome.self, from: response.data)
                    if let firstImageURL = results.items.first?.thumbnail {
                        DispatchQueue.global().async {
                            do {
                                let data = try Data(contentsOf: URL(string: firstImageURL)!)
                                DispatchQueue.main.async {
                                    self.imageView.image = UIImage(data: data)
                                    completion(firstImageURL)
                                }
                            } catch {
                                print("이미지 로드 실패")
                                completion(nil)
                            }
                        }
                    } else {
                        print("이미지를 찾을 수 없음")
                        completion(nil)
                    }
                } catch {
                    print("search Image 디코딩 실패: \(error)")
                    completion(nil)
                }
            case .failure(let error):
                print("Network request error: \(error)")
                completion(nil)
            }
        }
    }

}
func extractImageURL(from data: Data) -> String? {
    do {
        let decoder = JSONDecoder()
        let results = try decoder.decode([ImageItem].self, from: data)
        if let firstImageURL = results.first?.thumbnail {
            return firstImageURL
        } else {
            print("이미지를 찾을 수 없음")
            return nil
        }
    } catch {
        print("search Image 디코딩 실패: \(error)")
        return nil
    }
}

