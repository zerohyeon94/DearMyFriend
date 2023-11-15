import UIKit
import NMapsMap
import CoreLocation
import Moya
import SnapKit
import Kingfisher
import Firebase
import Toast
import FirebaseAuth


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
    var modalData: (title: String, roadAddress: String)?
    //    var searchRadius: CLLocationDistance = 1000
    var selectedResult: (title: String, roadAddress: String, telephone: String)?
    var userLocations: [CLLocationCoordinate2D] = []
    var userMarkers: [String: NMFMarker] = [:]






    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        return imageView

    }()

    //    private lazy var showAnimalHospitalButton: UIButton = {
    //        let button = createStyledButton(title: "동물병원")
    //        button.addTarget(self, action: #selector(showAnimalHospital), for: .touchUpInside)
    //        return button
    //    }()


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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMarkersToFirestore()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        loadMarkersFromFirestore()

        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchResultCell)

        naverMapView = NMFNaverMapView(frame: self.view.frame)
        naverMapView?.showLocationButton = true
        naverMapView?.mapView.isScrollGestureEnabled = true
        naverMapView?.mapView.delegate = self
        searchController.searchBar.delegate = self
        naverMapView?.mapView.addCameraDelegate(delegate: self)


        addTableView()


        if let naverMapView = naverMapView {
            self.view.addSubview(naverMapView)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)

        //        setupButtonLayout()
        setupLocationManager()
        if let currentLocation = locationManager.location {
            addMarker(at: currentLocation.coordinate, title: "현재 위치입니다.")
            moveMapToLocation(currentLocation.coordinate)
        }

    }

    private func createStyledButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }
    func mapView(_ mapView: NMFMapView, cameraIsIdle isIdle: Bool) {
        if isIdle {
            loadMarkersInVisibleArea()
        }

        func loadMarkersInVisibleArea() {
            guard let mapView = naverMapView?.mapView else {
                return
            }

            let cameraPosition = mapView.cameraPosition
            let center = CLLocationCoordinate2D(latitude: cameraPosition.target.lat, longitude: cameraPosition.target.lng)
            let zoomLevel = cameraPosition.zoom

            FirestoreManager.shared.fetchDataInVisibleArea(center: center, zoomLevel: zoomLevel) { [weak self] documents in
                for document in documents {
                    let data = document.data()
                    if let latitude = data["latitude"] as? Double,
                       let longitude = data["longitude"] as? Double,
                       let title = data["title"] as? String,
                       let roadAddress = data["roadAddress"] as? String {
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self?.addMarker(at: coordinate, title: title)
                    }
                }
            }
        }
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
        searchController.searchBar.placeholder = "찿으시는 매장이름과 지역을 입력하세요!"
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        definesPresentationContext = true
        //                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //                searchController.view.addGestureRecognizer(tapGesture)

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

    func saveMarkersToFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        let markersCollection = db.collection("24시간동물병원2")

        for (index, marker) in (self.markers ?? []).enumerated() {
            if marker.captionText != "현재 위치입니다." {
                let modalData = searchResults.first(where: { $0.title == marker.captionText })
                let modalTitle = modalData?.title ?? ""
                let modalRoadAddress = modalData?.roadAddress

                let markerData: [String: Any] = [
                    "userID": uid,
                    "latitude": marker.position.lat,
                    "longitude": marker.position.lng,
                    "title": marker.captionText ?? "",
                    "roadAddress": modalRoadAddress,
                    "modalData": [
                        "title": modalTitle,
                        "roadAddress": modalRoadAddress
                    ]
                ]

                let docRef = markersCollection.document(marker.captionText ?? "")

                docRef.getDocument { (documentSnapshot, error) in
                    if let document = documentSnapshot, document.exists {
                        docRef.updateData(["modalData": markerData]) { error in
                            if let error = error {
                                print("마커 데이터 업데이트 오류: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        docRef.setData(markerData) { error in
                            if let error = error {
                                print("마커 데이터 저장 오류: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }


    func loadMarkersFromFirestore() {
        let db = Firestore.firestore()
        let markersCollection = db.collection("24시간동물병원2")

        markersCollection.getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("문서 가져오기 오류: \(error?.localizedDescription ?? "")")
                return
            }

            for document in documents {
                let data = document.data()
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double,
                   let title = data["title"] as? String,
                   let roadAddress = data["roadAddress"] as? String,
                   let modalDataDict = data["modalData"] as? [String: Any] {

                    let modalTitle = modalDataDict["title"] as? String
                    let modalRoadAddress = modalDataDict["roadAddress"] as? String
                    // let modalImageView = modalDataDict["imageView"] // imageView를 적절한 타입으로 변환해야 합니다.

                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                    // 중복 체크 및 현재 사용자의 마커인지 확인
                    // if let uid = Auth.auth().currentUser?.uid,
                    //    let markerUserID = data["userID"] as? String,
                    //    markerUserID == uid {
                    self?.addMarker(at: coordinate, title: title, roadAddress: roadAddress, modalTitle: modalTitle ?? "", modalRoadAddress: modalRoadAddress ?? "")

                }
            }
            self?.setTouchHandlersForMarkers()

        }
    }
    func setTouchHandlersForMarkers() {
        for marker in markers {
            marker.touchHandler = { [weak self] overlay in
                if let marker = overlay as? NMFMarker {



                    let db = Firestore.firestore()
                    let markersCollection = db.collection("24시간동물병원2")
                    markersCollection.document(marker.captionText).getDocument { documentSnapshot, error in
                        if let document = documentSnapshot, document.exists {
                            let data = document.data()
                            let title = data?["title"] as? String ?? ""
                            let roadAddress = data?["roadAddress"] as? String ?? ""
                            self?.modalData = (title: title, roadAddress: roadAddress)
                            print("모달 데이터: \(self?.modalData)")

                            self?.showHalfModal()
                        }
                    }
                }
                return true
            }
        }
    }
//    @objc func showAnimalHospital() {
//        if isLoadingResults {
//            return
//        }
//        //        loadAnimalHospitalCoordinatesFromFirebase()
//
//        searchResults.removeAll()
//        searchStart = 1 // 다시 첫 번째 페이지부터 시작
//
//    }

    @objc func closeModal() {
        modalView.removeFromSuperview()
        selectedItem = nil
    }

    @objc func showHalfModal() {
        print("showHalfModal 함수 호출 확인")

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
                            // 이미지 로드 후 모달 표시
                            self.modalView.addSubview(self.imageView)

                        }
                    } else {
                        print("이미지 로드 실패")
                    }
                }
            }
        }
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 10
        self.view.addSubview(modalView)

        modalView.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.top.equalTo(modalView).offset(80)
            $0.leading.equalTo(modalView).offset(16)
            $0.trailing.equalTo(modalView).offset(-16)
            $0.height.equalTo(100)
        }

        locationNameLabel.text = data.title
        roadAddressLabel.text = data.roadAddress

        modalView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(350)
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
    func addMarker(at coordinate: CLLocationCoordinate2D, title: String, roadAddress: String? = nil, modalTitle: String? = nil, modalRoadAddress: String? = nil) {
        let isDuplicate = markers.contains { existingMarker in
            existingMarker.position.lat == coordinate.latitude &&
            existingMarker.position.lng == coordinate.longitude
        }

        if !isDuplicate {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
            marker.captionText = title

            if title.lowercased().contains("24") {
                // 24시간 동물병원 아이콘
                if let image = UIImage(named: "24") {
                    let resizedImage = ImageResizer.resizeImage(image: image, newWidth: 30)
                    marker.iconImage = NMFOverlayImage(image: resizedImage)
                }
                marker.iconTintColor = UIColor.red
            } else if ["동물병원", "센터", "의료"].contains(where: title.lowercased().contains) {
                // 일반 동물병원 아이콘
                if let image = UIImage(named: "animalhospital") {
                    let resizedImage = ImageResizer.resizeImage(image: image, newWidth: 30)
                    marker.iconImage = NMFOverlayImage(image: resizedImage)
                }
                marker.iconTintColor = UIColor.orange
            }

            marker.mapView = naverMapView?.mapView
            markers.append(marker)

            marker.touchHandler = { [weak self] overlay in
                if let marker = overlay as? NMFMarker {
                    let selectedItem = self?.searchResults.first(where: { $0.title == marker.captionText })
                    self?.modalData = selectedItem
                    print("모달 데이터: \(self?.modalData)")

                    self?.showHalfModal()

                }
                return true
            }
        }
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
                    self?.modalData = (title: selectedSearch, roadAddress: selectedSearch)
                    self?.showHalfModal()
                }
            }
        } else {
            let resultIndex = indexPath.row - recentSearches.count
            let selectedResult = searchResults[resultIndex]

            geocoder.geocodeAddressString(selectedResult.roadAddress) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    self?.moveMapToLocation(location.coordinate)
                    self?.addMarker(at: location.coordinate, title: selectedResult.title)
                    self?.modalData = (title: selectedResult.title, roadAddress: selectedResult.roadAddress)
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
        perform(#selector(delayedSearch(_:)), with: searchController, afterDelay: 0.5)
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

        isLoadingResults = true

        naverSearch.request(.search(query: query)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(Welcome.self, from: response.data)
                    self?.searchResults = results.items.map { (title: $0.cleanTitle(), roadAddress: $0.roadAddress ?? "") }
                    print("검색된 위치정보:\(self?.searchResults)")

                    for result in self?.searchResults ?? [] {
                        self?.geocodeAndAddMarker(for: result.title, roadAddress: result.roadAddress)
                    }

                    DispatchQueue.main.async {
                        self?.searchResultsTableView.reloadData()
                    }
                } catch {
                    print("JSON decoding error: \(error)")
                }
            case .failure(let error):
                print("Network request error: \(error)")
            }

            self?.isLoadingResults = false
        }
    }
    func showNoSearchResultsToast() {
          view.makeToast("해당지역은 아직 추가되지않은 지역입니다 ㅜㅜ")
      }
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

