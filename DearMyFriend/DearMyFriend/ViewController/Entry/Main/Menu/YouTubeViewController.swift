// 박철우-유튜브 뷰컨트롤러 페이지
import Firebase
import Lottie
import SnapKit
import UIKit
class YouTubeViewController: UIViewController {
    let fireStoreDataBase = Firestore.firestore()
    var compterPremierColDocSec: Int = 0
    var compterDeuxiemeColDocSec: Int = 0
    private let pageName = {
        let label = UILabel()
        label.text = "추천 유튜버"
        label.textColor = UIColor(named: "주요텍스트컬러")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    private let youtubeTableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        return tableView
    }()

    private let leftSide = {
        let side = UIView()
        side.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        side.layer.backgroundColor = UIColor(named: "태두리컬러")?.cgColor
        return side
    }()

    private let rightSide = {
        let side = UIView()
        side.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        side.layer.backgroundColor = UIColor(named: "태두리컬러")?.cgColor
        return side
    }()

    private var cellSelectAnime = {
        let animeView = LottieAnimationView(name: "로딩")

        animeView.contentMode = .scaleAspectFit

        animeView.loopMode = .loop

        animeView.animationSpeed = 1

        animeView.play()

        return animeView

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "뷰컬러")        // navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.hidesBackButton = true

        layoutForUI()
        layoutForSide()
        layoutForTableView()
        youtubeTableView.dataSource = self
        youtubeTableView.delegate = self
        youtubeTableView.register(YouTubeTableViewCell.self, forCellReuseIdentifier: "CellForYoutube")

        referenceEnTemps(nomDePreCol: "고양이 유튜브", nomDeDeuCol: "강아지 유튜브") { _, _ in
            self.youtubeTableView.reloadData()
        }
    }
}

extension YouTubeViewController {
    private func layoutForUI() {
        for ui in [pageName] {
            view.addSubview(ui)
        }
        pageName.snp.makeConstraints { make in
            make.width.equalTo(139)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(87)
        }
    }

    private func layoutForTableView() {
        view.addSubview(youtubeTableView)
        youtubeTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.bottom.equalToSuperview().offset(-49)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private func layoutForSide() {
        for side in [leftSide, rightSide] {
            view.addSubview(side)
        }
        leftSide.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(908)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        rightSide.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(908)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }

    func telechargerDesImg(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func telechargerDesInfos(collection: String, document: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let referenceDesDocs = fireStoreDataBase.collection(collection).document(document)
        referenceDesDocs.getDocument { document, erreur in
            if let document = document, document.exists {
                let donnees = document.data()
                completion(donnees, nil)
            } else {
                completion(nil, erreur)
            }
        }
    }

    func referenceEnTemps(nomDePreCol: String, nomDeDeuCol: String, completion: @escaping (Int, Int) -> Void) {
        let referencePreCol = fireStoreDataBase.collection(nomDePreCol)
        let referenceDeuCol = fireStoreDataBase.collection(nomDeDeuCol)

        referencePreCol.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching \(nomDePreCol): \(error)")
            } else {
                let count = snapshot?.documents.count ?? 0
                self.compterPremierColDocSec = count
                completion(self.compterPremierColDocSec, self.compterDeuxiemeColDocSec)
            }
        }

        referenceDeuCol.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching \(nomDeDeuCol): \(error)")
            } else {
                let count = snapshot?.documents.count ?? 0
                self.compterDeuxiemeColDocSec = count
                completion(self.compterPremierColDocSec, self.compterDeuxiemeColDocSec)
            }
        }
    }
}

extension YouTubeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "냥냥이 채널"
        } else if section == 1 {
            return "댕댕이 채널"
        }
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = UIColor(named: "뷰컬러")
            headerView.textLabel?.textColor = UIColor(named: "주요택스트컬러")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return compterPremierColDocSec
        } else {
            return compterDeuxiemeColDocSec
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForYoutube", for: indexPath) as! YouTubeTableViewCell
        let channelDocumentName = "채널\(indexPath.row + 1)"
        if indexPath.section == 0 {
            telechargerDesInfos(collection: "고양이 유튜브", document: channelDocumentName) { donnes, _ in
                if let imageURLString = donnes?["채널이미지"] as? String {
                    self.telechargerDesImg(from: imageURLString) { image in
                        DispatchQueue.main.async {
                            cell.youtubeImage.image = image
                        }
                    }
                }
            }

            telechargerDesInfos(collection: "고양이 유튜브", document: channelDocumentName) { donnes, _ in
                DispatchQueue.main.async {
                    cell.youtubeName.text = donnes?["채널제목"] as? String
                }
            }
            telechargerDesInfos(collection: "고양이 유튜브", document: channelDocumentName) { donnes, _ in
                DispatchQueue.main.async {
                    cell.youtubeExplanation.text = donnes?["채널소개"] as? String
                }
            }
        } else if indexPath.section == 1 {
            telechargerDesInfos(collection: "강아지 유튜브", document: channelDocumentName) { donnes, _ in
                if let imageURLString = donnes?["채널이미지"] as? String {
                    self.telechargerDesImg(from: imageURLString) { image in
                        DispatchQueue.main.async {
                            cell.youtubeImage.image = image
                        }
                    }
                }
            }

            telechargerDesInfos(collection: "강아지 유튜브", document: channelDocumentName) { donnes, _ in
                DispatchQueue.main.async {
                    cell.youtubeName.text = donnes?["채널제목"] as? String
                }
            }
            telechargerDesInfos(collection: "강아지 유튜브", document: channelDocumentName) { donnes, _ in
                DispatchQueue.main.async {
                    cell.youtubeExplanation.text = donnes?["채널소개"] as? String
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.addSubview(cellSelectAnime)
        cellSelectAnime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        pageName.isHidden = true
        youtubeTableView.isHidden = true
        leftSide.isHidden = true
        rightSide.isHidden = true
        let channelDocumentName = "채널\(indexPath.row + 1)"
        let collectionName: String

        if indexPath.section == 0 {
            collectionName = "고양이 유튜브"
        } else {
            collectionName = "강아지 유튜브"
        }

        telechargerDesInfos(collection: collectionName, document: channelDocumentName) { donnes, _ in
            if let selectedChannel = donnes {
                if let title = selectedChannel["채널제목"] as? String {
                    print("\(title) 링크로 이동")
                    let selectedLink = selectedChannel["채널링크"] as? String
                    if let url = URL(string: selectedLink ?? "") {
                        print("성공")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            self.cellSelectAnime.removeFromSuperview()
                            if self.pageName.isHidden == true, self.youtubeTableView.isHidden == true, self.leftSide.isHidden == true, self.rightSide.isHidden == true {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.pageName.isHidden = false
                                    self.youtubeTableView.isHidden = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
//
