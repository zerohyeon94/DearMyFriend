import UIKit

class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
    
    private static func showCancleAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
                
            }))
                            
            alert.addAction(UIAlertAction(title: "아니오", style: .default))
            vc.present(alert, animated: true)
        }
    }
    
    private static func reportAlert(documentID: String ,on vc: UIViewController, title: String, message: String?, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
                
                FeedService.shared.reportFeed(documentID) { result in
                    switch result {
                    case .success():
                        self.reportCommentCompleteAlert(on: vc)
                        completion()
                    case .failure(let error):
                        self.failureFeed(on: vc, with: error)
                    }
                }
                
            }))
                            
            alert.addAction(UIAlertAction(title: "아니오", style: .default))
            vc.present(alert, animated: true)
        }
    }
    
    private static func showReportCommentAlert(_ comment: String,_ documentID: String ,on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
                
                CommentService.shared.reportComment(comment, documentID) { result in
                    switch result {
                    case .success():
                        self.reportCommentCompleteAlert(on: vc)
                    case .failure(let error):
                        self.failureFeed(on: vc, with: error)
                    }
                }
            }))
                            
            alert.addAction(UIAlertAction(title: "아니오", style: .default))
            vc.present(alert, animated: true)
        }
    }
    
    private static func showActionAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                AuthService.shared.signOut { error in
                    if let error = error {
                        self.certificationCheckAlert(on: vc, with: error)
                    } else {
                        AuthService.shared.changeController(vc)
                    }
                }
            }))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Log In Errors
extension AlertManager {
    
    public static func logoutAlert(on vc: UIViewController) {
        self.showActionAlert(on: vc, title: "토큰인증 만료", message: "재로그인 후 시도해주십시오.")
    }
    
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
    
    public static func failureFeed(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "네트워크 실패", message: "서버와 통신이 불안정합니다.\n잠시 후 다시 시도해주세요.")
        print("-----Feed ERROR \(error.localizedDescription)-----")
    }
    
    public static func errorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "지연오류", message: "정보를 읽어오지 못했습니다.")
    }
    
    // MARK: - 신고하기(게시글)
    public static func reportAlert(on vc: UIViewController, documentID: String, completion: @escaping () -> Void) {
        self.reportAlert(documentID: documentID, on: vc, title: "신고하기", message: "게시글을 신고하시겠습니까?") {
            completion()
        }
    }
    
    public static func reportCompleteAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "신고완료", message: "감사합니다.")
    }
    
    // MARK: - 신고하기(댓글)
    public static func reportCommentAlert(on vc: UIViewController,_ comment: String,_ documentID: String) {
        self.showReportCommentAlert(comment, documentID, on: vc, title: "신고하기", message: "댓글을 신고하시겠습니까?")
    }
    
    public static func reportCommentCompleteAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "신고완료", message: "신고 내용은 24시간 이내에\n조치됩니다.")
    }
}
