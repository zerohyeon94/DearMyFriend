import Foundation
import UIKit

class MyPetInfoView: UIView {
    // MARK: Properties
    // TableView
    private let petInfoTableView = UITableView()
    
    // MARK: Initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure & Constant
    func setupTableView(){
        petInfoTableView.dataSource = self
        
        petInfoTableView.separatorStyle = .none // Cell 사이 줄 제거
        let petInfoCellHeight: CGFloat = 150 // Cell의 여유분의 높이 10을 줌.
        petInfoTableView.rowHeight = petInfoCellHeight
        petInfoTableView.register(MyPetTableViewCell.self, forCellReuseIdentifier: MyPetTableViewCell.identifier)
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        addSubview(petInfoTableView)
        petInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            petInfoTableView.topAnchor.constraint(equalTo: topAnchor),
            petInfoTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            petInfoTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            petInfoTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension MyPetInfoView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // 추후 받는 데이터 보고 결정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPetTableViewCell.identifier, for: indexPath) as! MyPetTableViewCell
        cell.selectionStyle = .none // cell 선택 효과 없애기
        
        cell.cellIndex = indexPath.row
        
        let petDummyData: PetData = PetData(petProfile: "one", petName: "pet Name", petAge: 1, petType: "pet Type")
        cell.setPetInfo(petData: petDummyData, index: indexPath.row)
        
        return cell
    }
}
