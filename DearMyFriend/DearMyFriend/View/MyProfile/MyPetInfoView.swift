import Foundation
import UIKit

class MyPetInfoView: UIView {
    // MARK: Properties
    // TableView
    let petInfoTableView = UITableView()
    
    // MARK: Initalizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("MyPetInfoView 실행")
        
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure & Constant
    func setupTableView(){
        print("setupTableView 실행")
        
        
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
    
    func reloadTableView() {
        print("reloadTableView")
        petInfoTableView.dataSource = self
        
        petInfoTableView.reloadData()
    }
}

extension MyPetInfoView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userPetData = MyViewController.myProfileData
        print("userPetData.petName.count: \(userPetData.petName.count)")
        return userPetData.petName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPetTableViewCell.identifier, for: indexPath) as! MyPetTableViewCell
        cell.selectionStyle = .none // cell 선택 효과 없애기
        cell.cellIndex = indexPath.row
        
        let userPetData = MyViewController.myProfileData
        
        let petProfile = userPetData.petProfile[indexPath.row]
        let petName = userPetData.petName[indexPath.row]
        let petAge = userPetData.petAge[indexPath.row]
        let petType = userPetData.petType[indexPath.row]
        
        let petData: PetData = PetData(petProfile: petProfile, petName: petName, petAge: petAge, petType: petType)
        print("petData: \(petData)")
        cell.setPetInfo(petData: petData, index: indexPath.row)
        
        return cell
    }
}
