// 박철우-계산기페이지

import Lottie
import SnapKit
import UIKit


class CalculatorViewController: UIViewController {
    var 상태선택: 고양이상태 = .생후4개월미만
    private let statePickerView = UIPickerView()
    private let 사료PickerView = UIPickerView()
    private let 고양이상태목록: [고양이상태] = [.Select, .생후4개월미만, .생후4에서6개월, .생후7에서12개월, .일반성묘, .중성화된성묘, .활동량많은고양이, .노묘, .비만고양이]
    
    
    private let 하단_블록 = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.08)
        uiView.layer.cornerRadius = 20
        uiView.layer.borderColor = UIColor(named: "border")?.cgColor
        uiView.layer.borderWidth = 3
        return uiView
    } ()
    
    private let selectLabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "maintext")
        label.textAlignment = .center
        label.text = "반려동물 선택"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let 고양이버튼 = {
        let button = UIButton()
        button.setImage(UIImage(named: "caton"), for: .selected)
        button.contentMode = .scaleAspectFit
        button.layer.borderWidth = 3
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
    private let 칼로리 = {
        let textField = UITextField()
        textField.placeholder = "사료10g당 Kcal"
        textField.contentVerticalAlignment = .center
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "maintext")
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 3
        textField.tintColor = .magenta
        textField.clearButtonMode = .always
        textField.isUserInteractionEnabled = true


        return textField
    } ()
    private let targetAnimal = {
        let label = UILabel()
        label.textColor = UIColor(named: "maintext")
        label.textAlignment = .center
        label.text = "반려동물 정보"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let 고양이상태선택 = {
        let textField = UITextField()
        textField.placeholder = "----- 상태 선택 -----"
        textField.contentVerticalAlignment = .center
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "maintext")
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 3
        textField.tintColor = .clear
        textField.isUserInteractionEnabled = true
        
        return textField
    }()
    
    private let 몸무게입력: UITextField = {
        let textField = UITextField()
        textField.placeholder = "몸무게(kg)를 입력해주세요."
        textField.contentVerticalAlignment = .center
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "maintext")
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 3
        textField.tintColor = .magenta
        textField.clearButtonMode = .always
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    private let 계산버튼 = {
        let button = UIButton()
        button.setTitle("계산하기", for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.borderColor = UIColor(named: "border")?.cgColor
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.4)
        button.isSelected = !button.isSelected
        
        return button
    }()
    
    private var result = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(named: "maintext")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
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
    private var 일일권장칼로리 = {
        let label = UILabel()
        label.text = " 권장 칼로리 : "
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private var 일일기초대사량 = {
        let label = UILabel()
        label.text = " 기초 대사량 : "
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var 사료급여량 = {
        let label = UILabel()
        label.text = " 사료 급여량 : "
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var 결과창보기 = {
        let label = UILabel()
        label.text = "계산결과"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    } ()
    private var 칼로리결과 = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.purple
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .right
        return label
    }()
    private var 칼로리결과단위 = {
        let label = UILabel()
        label.text = "Kcal (칼로리)"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private var 대사량결과 = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.purple
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .right
        return label
    }()
    private var 대사량결과단위 = {
        let label = UILabel()
        label.text = "Kcal (칼로리)"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private var 사료량결과 = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.purple
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .right
        return label
    }()
    private var 사료량결과단위 = {
        let label = UILabel()
        label.text = "g (그람)         "
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.backgroundColor = UIColor(named: "view")
        title = "사료량 계산기"
        self.navigationController?.navigationBar.tintColor = .black
        statePickerView.delegate = self
        statePickerView.dataSource = self
        사료PickerView.delegate = self
        사료PickerView.dataSource = self
        
        고양이상태선택.delegate = self
        고양이상태선택.inputView = statePickerView
        
        유아이레이아웃()
        계산기화면레이아웃()
        칼로리.delegate = self
        몸무게입력.delegate = self
        clickEvent()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
           view.addGestureRecognizer(tapGesture)
    }
   
    @objc func viewTapped() {
        view.endEditing(true)
    }
    func calculateFoodAmount(몸무게: String, 상태: 고양이상태) -> (칼로리: String, 대사량: String, 사료량: String) {
        guard let weightDouble = Double(몸무게) else {
            return ("error", "error", "error")
        }
        
        let 기초대사량 = 30 * weightDouble + 70
        let 일일_권장_칼로리 = 기초대사량 * 상태.가중치
        let 사료10g당칼로리String = 칼로리.text ?? ""
        let 사료10g당칼로리 = Double(사료10g당칼로리String) ?? 0.0
        let 급여량 = 일일_권장_칼로리 / 사료10g당칼로리 * 10
        
        let result = (
            칼로리: "\(round(일일_권장_칼로리 * 10) / 10)",
            대사량: "\(round(기초대사량 * 10) / 10)",
            사료량: "\(round(급여량 * 10) / 10)"
        )
        
        return result
    }
    @objc func 계산버튼클릭() {
        print("계산중")
        let resultInfo = calculateFoodAmount(몸무게: 몸무게입력.text ?? "", 상태: 상태선택)
        칼로리결과.text = resultInfo.칼로리
        대사량결과.text = resultInfo.대사량
        사료량결과.text = resultInfo.사료량
        몸무게입력.text = ""
        칼로리.text = ""
    }
    
    func clickEvent() {
        고양이버튼.addTarget(self, action: #selector(고양이버튼클릭), for: .touchUpInside)
        계산버튼.addTarget(self, action: #selector(계산버튼클릭), for: .touchUpInside)
    }
    @objc func 고양이버튼클릭() {
        if !고양이버튼.subviews.contains(checking) {
            고양이버튼.addSubview(checking)
            checking.snp.remakeConstraints { make in
                make.top.trailing.equalTo(고양이버튼)
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            print("고양이 버튼이 클릭되었습니다.")
            targetAnimal.text = "냥냥이 & 사료 정보"
            checking.play()
        } else if 고양이버튼.subviews.contains(checking) {
            checking.removeFromSuperview()
            print("버튼클릭 취소")
            targetAnimal.text = "반려동물 & 사료 정보"
        }
    }
}

extension CalculatorViewController  {
   
    func 유아이레이아웃() {
        for 유아이 in [ selectLabel, targetAnimal, 고양이버튼] {
            view.addSubview(유아이)
        }
        selectLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(130)
            make.leading.equalToSuperview().offset(70)
        }
        targetAnimal.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(150)
            make.leading.equalTo(selectLabel)
        }
        고양이버튼.snp.makeConstraints { make in
            make.top.equalTo(selectLabel).offset(40)
            make.width.equalTo(160)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    func 계산기화면레이아웃() {
        for 계산기유아이 in [고양이상태선택, 칼로리, 몸무게입력, 계산버튼, 일일권장칼로리,일일기초대사량,사료급여량, 하단_블록, 결과창보기,칼로리결과단위,대사량결과단위,사료량결과단위,칼로리결과,대사량결과,사료량결과] {
            view.addSubview(계산기유아이)
        }
        고양이상태선택.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(targetAnimal.snp.bottom).offset(20)
        }
        칼로리.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(고양이상태선택.snp.bottom).offset(17)
        }
        몸무게입력.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(칼로리.snp.bottom).offset(17)
        }
        계산버튼.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(35)
            make.top.equalTo(몸무게입력.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        결과창보기.snp.makeConstraints { make in
            make.top.equalTo(하단_블록.snp.top).offset(15)
            make.centerX.equalToSuperview()
        }
        일일권장칼로리.snp.makeConstraints { make in
            make.top.equalTo(결과창보기.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(45)
        }
        일일기초대사량.snp.makeConstraints { make in
            make.top.equalTo(일일권장칼로리.snp.bottom).offset(25)
            make.leading.equalTo(일일권장칼로리)
        }
        사료급여량.snp.makeConstraints { make in
            make.top.equalTo(일일기초대사량.snp.bottom).offset(25)
            make.leading.equalTo(일일권장칼로리)
        }
        칼로리결과단위.snp.makeConstraints { make in
            make.centerY.equalTo(일일권장칼로리)
            make.trailing.equalToSuperview().offset(-45)
        }
        대사량결과단위.snp.makeConstraints { make in
            make.centerY.equalTo(일일기초대사량)
            make.trailing.equalToSuperview().offset(-45)

        }
        사료량결과단위.snp.makeConstraints { make in
            make.centerY.equalTo(사료급여량)
            make.trailing.equalToSuperview().offset(-45)
        }
        칼로리결과.snp.makeConstraints { make in
            make.centerY.equalTo(일일권장칼로리)
            make.trailing.equalTo(칼로리결과단위.snp.leading).offset(-10)
        }
        대사량결과.snp.makeConstraints { make in
            make.centerY.equalTo(일일기초대사량)
            make.trailing.equalTo(대사량결과단위.snp.leading).offset(-10)

        }
        사료량결과.snp.makeConstraints { make in
            make.centerY.equalTo(사료급여량)
            make.trailing.equalTo(사료량결과단위.snp.leading).offset(-10)

        }
        하단_블록.snp.makeConstraints { make in
            make.top.equalTo(계산버튼.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-83)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
    
}

extension CalculatorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let isNumeric = string.isEmpty || (string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789.").inverted) == nil)
        let maximumtextLengthInTextField = (textField.text?.count ?? 0) + string.count - range.length
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        let isDouble = Double(newText ?? "") != nil
        
        return isNumeric && isDouble && maximumtextLengthInTextField <= 5
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == 고양이상태선택 {
            showPickerView(pickerView: statePickerView, textField: 고양이상태선택)
        }
        textField.becomeFirstResponder()

    }
    
    private func showPickerView(pickerView: UIPickerView, textField: UITextField) {
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
    }
}

extension CalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statePickerView {
            return 고양이상태목록.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == statePickerView {
            return "\(고양이상태목록[row])"
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statePickerView {
            상태선택 = 고양이상태목록[row]
            고양이상태선택.text = "\(상태선택)"
        }
        고양이상태선택.resignFirstResponder()
    }
}
