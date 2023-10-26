// 박철우-계산기페이지

import Lottie
import SnapKit
import UIKit
enum 고양이상태 {
    case Select
    case 생후4개월미만
    case 생후4에서6개월
    case 생후7에서12개월
    case 일반성묘
    case 중성화된성묘
    case 활동량많은고양이
    case 노묘
    case 비만고양이

    var 가중치: Double {
        switch self {
        case .Select:
            return 0
        case .생후4개월미만:
            return 3.0
        case .생후4에서6개월:
            return 2.5
        case .생후7에서12개월:
            return 2.0
        case .일반성묘:
            return 1.4
        case .중성화된성묘:
            return 1.2
        case .활동량많은고양이:
            return 1.6
        case .노묘:
            return 0.7
        case .비만고양이:
            return 0.8
        }
    }
}

enum 고양이사료종류 {
    case Select
    case 로얄캐닌_인도어
    case 건강백서_기능성
    case 힐스_어덜트웨이트
    case 퓨리나_성묘용

    var 사료: Double {
        switch self {
        case .Select:
            return 0
        case .로얄캐닌_인도어:
            return 37.7
        case .건강백서_기능성:
            return 31.9
        case .힐스_어덜트웨이트:
            return 33.6
        case .퓨리나_성묘용:
            return 34
        }
    }
}

class CalculatorViewController: UIViewController {
    var 상태선택: 고양이상태 = .생후4개월미만
    var 사료선택: 고양이사료종류 = .로얄캐닌_인도어
    private let statePickerView = UIPickerView()
    private let 사료PickerView = UIPickerView()
    private let 고양이상태목록: [고양이상태] = [.Select, .생후4개월미만, .생후4에서6개월, .생후7에서12개월, .일반성묘, .중성화된성묘, .활동량많은고양이, .노묘, .비만고양이]
    private let 고양이사료목록: [고양이사료종류] = [.Select, .로얄캐닌_인도어, .건강백서_기능성, .힐스_어덜트웨이트, .퓨리나_성묘용]
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

        label.text = "사료 급여량 계산기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "maintext")
        label.textAlignment = .left

        return label
    }()

    private let selectLabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "maintext")
        label.textAlignment = .center
        label.text = "반려동물 선택"
        return label
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

    private let 고양이사료선택 = {
        let textField = UITextField()
        textField.placeholder = "----- 사료 선택 -----"
        textField.contentVerticalAlignment = .center
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.textColor = UIColor(named: "maintext")
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor(named: "border")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.tintColor = .clear
        textField.isUserInteractionEnabled = true

        return textField
    }()
    let testLAbel = { // test label
        let label = UILabel()
        label.text = "asdfsafdsf"
        label.textColor = UIColor.black
        return label
    } ()
    private let targetAnimal = {
        let label = UILabel()
        label.textColor = UIColor(named: "maintext")
        label.textAlignment = .center
        label.text = "반려동물 정보"
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
        textField.layer.borderWidth = 2.0
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
        textField.layer.borderWidth = 2.0
        textField.tintColor = .magenta
        textField.clearButtonMode = .whileEditing
        textField.clearsOnBeginEditing = true
        textField.isUserInteractionEnabled = true

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.backgroundColor = UIColor(named: "view")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.hidesBackButton = true
        statePickerView.delegate = self
        statePickerView.dataSource = self
        사료PickerView.delegate = self
        사료PickerView.dataSource = self

        고양이상태선택.delegate = self
        고양이상태선택.inputView = statePickerView

        고양이사료선택.delegate = self
        고양이사료선택.inputView = 사료PickerView

        유아이레이아웃()
        계산기화면레이아웃()
        몸무게입력.delegate = self
        clickEvent()
    }

    func 유아이레이아웃() {
        for 유아이 in [leftSide, rightSide, pageName, selectLabel, targetAnimal, 고양이버튼, 몸무게입력] {
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
            make.leading.equalTo(leftSide.snp.trailing).offset(32)
            make.top.equalToSuperview().offset(87)
        }
        selectLabel.snp.makeConstraints { make in
            make.width.equalTo(138)
            make.height.equalTo(24)
            make.top.equalTo(pageName.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(128)
        }
        targetAnimal.snp.makeConstraints { make in
            make.width.equalTo(138)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalTo(selectLabel.snp.bottom).offset(200)
            make.leading.equalToSuperview().offset(80)
        }

        고양이버튼.snp.makeConstraints { make in
            make.top.equalTo(selectLabel).offset(40)
            make.width.equalTo(130)
            make.height.equalTo(130)
            make.centerX.equalToSuperview()
        }
    }

    func 계산기화면레이아웃() {
        for 계산기유아이 in [고양이상태선택, 고양이사료선택, 몸무게입력, 계산버튼, result, warnning] {
            view.addSubview(계산기유아이)
        }
        고양이상태선택.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(targetAnimal.snp.bottom).offset(5)
        }
        고양이사료선택.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(고양이상태선택.snp.bottom).offset(17)
        }
        몸무게입력.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.top.equalTo(고양이사료선택.snp.bottom).offset(17)
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
            make.leading.equalTo(계산버튼).offset(-25)
        }
        warnning.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(20)
            make.top.equalTo(result.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
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

    func calculateFoodAmount(몸무게: String, 상태: 고양이상태, 사료: 고양이사료종류) -> String {
        guard let weightDouble = Double(몸무게) else {
            return "올바른 몸무게를 입력해주세요."
        }

        let 기초대사량 = 30 * weightDouble + 70

        let 일일_권장_칼로리 = 기초대사량 * 상태.가중치

        let 사료10g당칼로리 = 사료.사료

        let 급여량 = 일일_권장_칼로리 / 사료10g당칼로리 * 10

        let resultInfo = """
        기초 대사량 : \(round(기초대사량 * 10) / 10) Kcal(칼로리)
        권장 칼로리 : \(round(일일_권장_칼로리 * 10) / 10) kcal(칼로리)
        선택된 사료 : \(사료) 사료 정보 - 10g 당 \(사료.사료) Kcal(칼로리)
        사료 급여량 : \(round(급여량 * 10) / 10) g(그람)
        """

        return resultInfo
    }

    @objc func 계산버튼클릭() {
        print("계산중")
        계산버튼.isSelected = true
        let resultInfo = calculateFoodAmount(몸무게: 몸무게입력.text ?? "", 상태: 상태선택, 사료: 사료선택)
        result.text = "\(resultInfo)"

        계산버튼.isSelected = false
    }

    func clickEvent() {
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == 고양이상태선택 {
            showPickerView(pickerView: statePickerView, textField: 고양이상태선택)
        } else if textField == 고양이사료선택 {
            showPickerView(pickerView: 사료PickerView, textField: 고양이사료선택)
        }
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
        } else if pickerView == 사료PickerView {
            return 고양이사료목록.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == statePickerView {
            return "\(고양이상태목록[row])"
        } else if pickerView == 사료PickerView {
            return "\(고양이사료목록[row])"
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statePickerView {
            상태선택 = 고양이상태목록[row]
            고양이상태선택.text = "\(상태선택)"
        } else if pickerView == 사료PickerView {
            사료선택 = 고양이사료목록[row]
            고양이사료선택.text = "\(사료선택)"
        }
        고양이상태선택.resignFirstResponder()
        고양이사료선택.resignFirstResponder()
    }
    
}
