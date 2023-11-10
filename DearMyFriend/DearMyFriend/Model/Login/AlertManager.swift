import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Log In Errors
extension AlertManager {

    // 로그인 실패
    public static func loginFailedAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "로그인 실패", message: "입력한 정보를 확인해주세요.")
    }
    
    // 인증메일 성공, 실패
    public static func certificationSuccessAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "계정센터", message: "인증메일이 발송되었습니다.")
    }
    
    public static func certificationCheckAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "계정센터", message: "잠시 후에 다시 시도해주세요.")
        print("-----certification ERROR \(error.localizedDescription)-----")
    }
    
    public static func certificationCompleteAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "계정센터", message: "인증이 완료되었습니다.")
    }
    
    //회원가입 실패
    public static func registerCheckAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "계정센터", message: "서버와 통신이 불안정합니다.\n잠시 후 다시 시도해주세요.")
    }
    
    public static func emailCheckAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "이메일 체크", message: "중복된 이메일이 존재합니다.")
    }
    
    public static func bannerImageReadFail(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "배너 이미지", message: "정보를 읽어오지 못했습니다.")
    }
    
    public static func recommendationPlaceReadFail(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "추천 플레이스", message: "정보를 읽어오지 못했습니다.")
    }
    
    // 피드 게시물 업로드
    public static func notSelectedImageAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "피드 게시물 추가", message: "이미지가 선택되지 않았습니다")
    }
    
    public static func notEnteredTextAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "피드 게시물 추가", message: "텍스트가 입력되지 않았습니다")
    }
    
    public static func nothingAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "피드 게시물 추가", message: "이미지와 텍스트가 입력되지 않았습니다")
    }
}
