// 박철우-계산기페이지

import Lottie
import SnapKit
import UIKit

class CalculatorViewController: UIViewController {
    private let leftSide = {
        let side = UIView()
        side.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        side.layer.backgroundColor = UIColor(named: "side")?.cgColor
        return side
    }()
    
    private let rightSide = {
        let side = UIView()
        side.frame = CGRect(x: 0, y: 0, width: 20, height: 908)
        side.layer.backgroundColor = UIColor(named: "side")?.cgColor
        return side
    }()
    
    private let pageName = {
        let label = UILabel()
        
        label.text = "표준 사료 급여량 계산기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "maintext")
        label.textAlignment = .right
        
        return label
    }()
    
    private let selectLabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "maintext")
        label.textAlignment = .center
        label.text = "반려동물 선택"
        return label
    }()
    
    private let 강아지버튼 = {
        let button = UIButton()
        button.setImage(UIImage(named: "dogon"), for: .selected)
        button.contentMode = .scaleAspectFit
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "border")?.cgColor
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "dogoff"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.isSelected = true
        return button
    }()
    
    private let 고양이버튼 = {
        let button = UIButton()
        button.setImage(UIImage(named: "caton"), for: .selected)
        button.contentMode = .scaleAspectFit
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "border")?.cgColor
        button.layer.cornerRadius = 10
        button.setImage(UIImage(named: "catoff"), for: .normal)
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
        label.textColor = UIColor(named: "maintext")
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
        textField.textColor = UIColor(named: "maintext")
        
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.tintColor = .magenta
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = true
        
        return textField
    }()
    
    private let 계산버튼 = {
        let button = UIButton()
        button.setTitle("계산하기", for: .normal)
        button.setTitleColor(UIColor(named: "maintext"), for: .normal)
        button.setTitle("계산중", for: .selected)
        button.layer.borderColor = UIColor(named: "border")?.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.backgroundColor = UIColor.clear
        button.isSelected = false
        
        return button
    }()
    
    private var playingButton = {
        let animeView = LottieAnimationView(name: "calcul")
        animeView.contentMode = .scaleAspectFit
        animeView.loopMode = .playOnce
        animeView.animationSpeed = 1
        return animeView
        
    }()
    
    private var result = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "maintext")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var warnning = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "subtext")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.backgroundColor = UIColor(named: "view")
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
            make.top.equalTo(selectLabel.snp.bottom).offset(200)
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
        for 계산기유아이 in [몸무게입력, 계산버튼, result, warnning] {
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
            make.top.equalTo(몸무게입력.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        result.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(150)
            make.top.equalTo(계산버튼).offset(30)
            make.centerX.equalToSuperview()
        }
        warnning.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(20)
            make.top.equalTo(result.snp.bottom).offset(20)
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
            weightLabel.text = "냥냥이 몸무게"
        }
    }

    func calculateFeedingAmount(weightKg: String) -> (lowerLimit: Double, upperLimit: Double)? {
        guard let weight = Double(weightKg) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("몸무게를 입력해주세요.")
                self.계산버튼.isSelected = false
                self.result.text = "몸무게를 입력해주세요."
            }
            return nil
        }
        if weightLabel.text == "댕댕이 몸무게" {
            let lowerLimit = weight * 25
            let upperLimit = weight * 38
            몸무게입력.text = weightKg
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("댕댕이 체중이 \(weightKg)kg 일 때, 권장 사료 급여량은 \(lowerLimit)g 에서 \(upperLimit)g 사이입니다.")
                self.계산버튼.isSelected = false
                self.result.text = "댕댕이 체중이 \(weightKg)kg 일 때,\n권장 사료 급여량은\n\(lowerLimit)g 에서 \(upperLimit)g 사이입니다."
                self.warnning.text = "( 나이, 건강상태 등에 따라 다를 수 있습니다.)"

            }
            return (lowerLimit, upperLimit)
        }
        else if weightLabel.text == "냥냥이 몸무게" {
            let lowerLimit = weight * 20
            let upperLimit = weight * 30
            몸무게입력.text = weightKg
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("냥냥이 체중이 \(weightKg)kg 일 때, 권장 사료 급여량은 \(lowerLimit)g 에서 \(upperLimit)g 사이입니다.")
                self.계산버튼.isSelected = false
                self.result.text = "냥냥이 체중이 \(weightKg)kg 일 때,\n권장 사료 급여량은\n\(lowerLimit)g 에서 \(upperLimit)g 사이입니다."
                self.warnning.text = "( 나이, 건강상태 등에 따라 다를 수 있습니다.)"
            }
            return (lowerLimit, upperLimit)
        }
        
        else if weightLabel.text == "반려동물 몸무게" {
            print("댕댕이 혹은 냥냥이 둘중 하나를 선택해주세요")
            계산버튼.isSelected = false
            result.text = "댕댕이 혹은 냥냥이 둘중 하나를 선택해주세요"
        }

        return nil
    }

    @objc func 계산버튼클릭() {
        print("계산중")
        계산버튼.isSelected = true
        calculateFeedingAmount(weightKg: 몸무게입력.text ?? "")
    }
    
    func clickEvent() {
        강아지버튼.addTarget(self, action: #selector(강아지버튼클릭), for: .touchUpInside)
        고양이버튼.addTarget(self, action: #selector(고양이버튼클릭), for: .touchUpInside)
        계산버튼.addTarget(self, action: #selector(계산버튼클릭), for: .touchUpInside)
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
