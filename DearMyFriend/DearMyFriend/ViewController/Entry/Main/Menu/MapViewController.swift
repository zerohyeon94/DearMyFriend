import UIKit
import NMapsMap
import CoreLocation
import Moya
import SnapKit

class MapViewController: UIViewController {

    var locationManager = CLLocationManager()
    var naverMapView: NMFNaverMapView?
    let geocoder = CLGeocoder()
    var searchResults: [String] = []
    let naverSearch = MoyaProvider<NaverSearchService>()
    let SearchResultCell = "SearchResultCell"
    var markers: [NMFMarker] = []

    var searchResultsTableView: UITableView = UITableView()
    var searchController: UISearchController!
    var searchResultsTableViewController: UITableViewController!
    var recentSearches: [String] = []

    private lazy var showAnimalHospitalButton: UIButton = {
        let button = createStyledButton(title: "동물병원")
        button.addTarget(self, action: #selector(showAnimalHospital), for: .touchUpInside)
        return button
    }()

    private lazy var showPetShopsButton: UIButton = {
        let button = createStyledButton(title: "펫샵")
        button.addTarget(self, action: #selector(showPetShop), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchResultCell)

        naverMapView = NMFNaverMapView(frame: self.view.frame)
        naverMapView?.showLocationButton = true
        naverMapView?.mapView.isScrollGestureEnabled = true

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
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }

    private func setupButtonLayout() {
        view.addSubview(showAnimalHospitalButton)
        view.addSubview(showPetShopsButton)

        showAnimalHospitalButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }

        showPetShopsButton.snp.makeConstraints {
            $0.top.equalTo(showAnimalHospitalButton)
            $0.leading.equalTo(showAnimalHospitalButton).offset(112)
            $0.width.equalTo(showAnimalHospitalButton)
            $0.height.equalTo(showAnimalHospitalButton)
        }

        showAnimalHospitalButton.layer.cornerRadius = 10
        showPetShopsButton.layer.cornerRadius = 10
    }


    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            let status = locationManager.authorizationStatus
            if status == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if status == .authorizedWhenInUse || status == .authorizedAlways {
                locationManager.startUpdatingLocation()
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
        searchController.searchBar.placeholder = "검색할 위치를 입력하세요"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func addTableView() {
        searchResultsTableView.frame = view.bounds
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        view.addSubview(searchResultsTableView)
    }

    func handleSearchResults(_ results: [String]) {
        searchResults = results
        searchResultsTableView.reloadData()
    }

    @objc func showAnimalHospital() {
        searchLocalPlaces("동물병원")
    }

    @objc func showPetShop() {
        searchLocalPlaces("서울")

    }
}

// MARK: - CLLocationManagerDelegate Extension
extension MapViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            print("위치 권한이 부여되지 않았습니다.")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.addMarker(at: location.coordinate)
            }
        }
    }
}

// MARK: - UISearchBarDelegate Extension
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if let searchText = searchBar.text {
            geocoder.geocodeAddressString(searchText) { placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    let coordinate = location.coordinate
                    self.addMarker(at: coordinate)
                }
            }
        }
    }
    func addMarker(at coordinate: CLLocationCoordinate2D) {
        guard let mapView = naverMapView?.mapView else {
            print("NMFNaverMapView's mapView is nil")
            return
        }

        for marker in markers {
                       marker.mapView = nil
                   }
                   markers.removeAll()

                   let marker = NMFMarker()
                   marker.position = NMGLatLng(from: coordinate)
                   marker.mapView = mapView

                   markers.append(marker)
               }
           }
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count + recentSearches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        if indexPath.row < recentSearches.count {
            cell.textLabel?.text = recentSearches[indexPath.row]
        } else {
            cell.textLabel?.text = searchResults[indexPath.row - recentSearches.count]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < recentSearches.count {
            // Recent Searches를 선택한 경우
            let selectedSearch = recentSearches[indexPath.row]
            geocoder.geocodeAddressString(selectedSearch) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    let coordinate = location.coordinate
                    self?.moveMapToLocation(coordinate)
                }
            }
        } else {
            // Search Results를 선택한 경우

            let selectedSearch = searchResults[indexPath.row - recentSearches.count]
            geocoder.geocodeAddressString(selectedSearch) { [weak self] placemarks, error in
                print(selectedSearch)
                print(placemarks)
                if let placemark = placemarks?.first, let location = placemark.location {
                    let coordinate = location.coordinate



                    print("location: \(location), coordinate: \(coordinate)")
                    self?.searchResults = []
                    self?.searchResultsTableView.reloadData()

                    // 검색 결과 숨기는 애니메이션을 추가
                    UIView.animate(withDuration: 0.3) {
                        self?.searchResultsTableView.isHidden = true
                    }

                    // 위치로 이동하는 애니메이션 추가
                    self?.moveMapToLocation(coordinate)
                }
            }
        }
    }
    func moveMapToLocation(_ coordinate: CLLocationCoordinate2D) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: coordinate))
        naverMapView?.mapView.moveCamera(cameraUpdate)
    }
}

extension MapViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchLocalPlaces(searchText)
        }
    }

    func searchLocalPlaces(_ query: String) {
        naverSearch.request(.search(query: query, categories: ["동물병원", "펫샵"])) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(Welcome.self, from: response.data)

                    let placeNames = results.items.map { $0.cleanTitle() }
                    for item in results.items {
                                      let title = item.title
                                      let mapy = item.mapy
                                      let mapx = item.mapx

                                      print("Title: \(title), mapy: \(mapy), mapx: \(mapx)")
                                  }

                    if let self = self {
                        self.handleSearchResults(placeNames)

                        if let mapView = self.naverMapView?.mapView {
                            for item in results.items {
                                let coordinate = CLLocationCoordinate2D(latitude: Double(item.mapy) ?? 0, longitude: Double(item.mapx) ?? 0)

                                let marker = NMFMarker()
                                marker.position = NMGLatLng(from: coordinate)
                                marker.mapView = mapView

                                marker.captionText = item.title
                            }
                        }
                    }
                } catch {
                    print("JSON decoding error: \(error)")
                }
            case .failure(let error):
                print("Network request error: \(error)")
            }
        }
    }

    func addMarkersFromSearchResults(_ items: [Item]) {
        if let mapView = self.naverMapView?.mapView {
            for item in items {
                let coordinate = CLLocationCoordinate2D(latitude: Double(item.mapy) ?? 0, longitude: Double(item.mapx) ?? 0)

                let marker = NMFMarker()
                marker.position = NMGLatLng(from: coordinate)
                marker.mapView = mapView

                // 마커의 타이틀을 장소 이름으로 설정합니다.
                marker.captionText = item.title
            }
        }
    }
}
