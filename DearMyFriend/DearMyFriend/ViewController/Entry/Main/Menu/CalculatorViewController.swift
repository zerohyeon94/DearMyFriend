// 박철우-계산기페이지

import Lottie
import SnapKit
import UIKit

class CalculatorViewController: UIViewController {
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
    
    private let pageName = {
        let label = UILabel()
        
        label.text = "표준 사료 급여량 계산기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "일반택스트컬러")
        label.textAlignment = .right
        
        return label
    }()
    
    private let selectLabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "주요택스트컬러")
        label.textAlignment = .center
        label.text = "반려동물 선택"
        return label
    }()
    
    private let 강아지버튼 = {
        let button = UIButton()
        button.setImage(UIImage(named: "강아지예스클릭"), for: .selected)
        button.contentMode = .scaleAspectFit
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "보더컬러")?.cgColor
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "강아지노클릭"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isSelected = true
        return button
    }()
    
    private let 고양이버튼 = {
        let button = UIButton()
        button.setImage(UIImage(named: "고양이예스클릭"), for: .selected)
        button.contentMode = .scaleAspectFit
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "보더컬러")?.cgColor
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "고양이노클릭"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isSelected = true
        return button
    }()
    
    private var checking = {
        let animeView = LottieAnimationView(name: "checking")
        animeView.contentMode = .scaleAspectFit
        animeView.loopMode = .playOnce
        animeView.animationSpeed = 5
        return animeView
        
    }()
    
    private let weightLabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "주요택스트컬러")
        label.textAlignment = .center
        label.text = "반려동물 몸무게"
        return label
    }()
    
    private let 몸무게입력 = {
        let textField = UITextField()
        textField.placeholder = "몸무게(kg)를 입력해주세요."
        textField.contentVerticalAlignment = .center
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "텍스트컬러")
        
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor(named: "보더컬러")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.tintColor = .magenta
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = true
        
        return textField
    }()
    
    private let 계산버튼 = {
        let button = UIButton()
        button.setTitle("계산하기", for: .normal)
        button.setTitleColor(UIColor(named: "주요택스트컬러"), for: .normal)
        button.setTitle("계산중", for: .selected)
        button.layer.borderColor = UIColor(named: "보더컬러")?.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.clear
        button.isSelected = false
        
        return button
    }()
    
    private var playingButton = {
        let animeView = LottieAnimationView(name: "계산버튼")
        animeView.contentMode = .scaleAspectFit
        animeView.loopMode = .playOnce
        animeView.animationSpeed = 1
        return animeView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.backgroundColor = UIColor(named: "뷰컬러")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.hidesBackButton = true
        
        유아이레이아웃()
        계산기화면레이아웃()
        몸무게입력.delegate = self
        clickEvent()
    }
    
    func 유아이레이아웃() {
        for 유아이 in [leftSide, rightSide, pageName, selectLabel, weightLabel, 강아지버튼, 고양이버튼, 몸무게입력] {
            view.addSubview(유아이)
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
        pageName.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(32)
            make.top.equalToSuperview().offset(87)
        }
        selectLabel.snp.makeConstraints { make in
            make.width.equalTo(138)
            make.height.equalTo(24)
            make.top.equalTo(pageName.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(128)
        }
        weightLabel.snp.makeConstraints { make in
            make.width.equalTo(138)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(selectLabel.snp.bottom).offset(261)
            make.leading.equalToSuperview().offset(80)
        }
        강아지버튼.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(130)
            make.top.equalToSuperview().offset(216)
            make.leading.equalToSuperview().offset(46)
            make.trailing.equalTo(고양이버튼.snp.leading).offset(-47)
        }
        고양이버튼.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(130)
            make.top.equalTo(강아지버튼)
            make.trailing.equalToSuperview().offset(-46)
        }
    }
    
    func 계산기화면레이아웃() {
        for 계산기유아이 in [몸무게입력, 계산버튼] {
            view.addSubview(계산기유아이)
        }
        몸무게입력.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(weightLabel.snp.bottom).offset(17)
        }
        계산버튼.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(35)
            make.top.equalTo(몸무게입력.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func 강아지버튼클릭() {
        if !고양이버튼.subviews.contains(checking) && !강아지버튼.subviews.contains(checking) {
            강아지버튼.addSubview(checking)
            checking.snp.remakeConstraints { make in
                make.top.trailing.equalTo(강아지버튼)
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            checking.play()
            print("강아지 버튼이 클릭되었습니다.")
            weightLabel.text = "댕댕이 몸무게"
        }
        else if !고양이버튼.subviews.contains(checking) && 강아지버튼.subviews.contains(checking) {
            checking.removeFromSuperview()
            print("버튼클릭 취소")
            weightLabel.text = "반려동물 몸무게"
        }
        else if 고양이버튼.subviews.contains(checking) {
            checking.removeFromSuperview()
            강아지버튼.addSubview(checking)
            checking.snp.remakeConstraints { make in
                make.top.trailing.equalTo(강아지버튼)
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            checking.play()
            print("고양이버튼에서 강아지 버튼으로 클릭되었습니다.")
            weightLabel.text = "댕댕이 몸무게"
        }
    }
    
    @objc func 고양이버튼클릭() {
        if !강아지버튼.subviews.contains(checking) && !고양이버튼.subviews.contains(checking) {
            고양이버튼.addSubview(checking)
            checking.snp.remakeConstraints { make in
                make.top.trailing.equalTo(고양이버튼)
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            print("고양이 버튼이 클릭되었습니다.")
            weightLabel.text = "냥냥이 몸무게"
            checking.play()
        }
        else if !강아지버튼.subviews.contains(checking) && 고양이버튼.subviews.contains(checking) {
            checking.removeFromSuperview()
            print("버튼클릭 취소")
            weightLabel.text = "반려동물 몸무게"
        }
        else if 강아지버튼.subviews.contains(checking) {
            checking.removeFromSuperview()
            고양이버튼.addSubview(checking)
            checking.snp.remakeConstraints { make in
                make.top.trailing.equalTo(고양이버튼)
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            checking.play()
            print("강아지버튼에서 고양이버튼이 클릭되었습니다.")
            weightLabel.text = "반려동물 몸무게"
        }
    }
    
    func clickEvent() {
        강아지버튼.addTarget(self, action: #selector(강아지버튼클릭), for: .touchUpInside)
        고양이버튼.addTarget(self, action: #selector(고양이버튼클릭), for: .touchUpInside)
    }
}
   
extension CalculatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        let maximumtextLengthInTextField = (textField.text?.count ?? 0) + string.count - range.length

        return allowedCharacters.isSuperset(of: characterSet) && maximumtextLengthInTextField <= 3
    }
}
