import Foundation

class Validator {
    
    static func checkNumber(for password: String) -> Bool {
        let username = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameRegEx = ".{8,}"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        print(usernamePred.evaluate(with: username))
        return usernamePred.evaluate(with: username)
    }
    
    static func checkIncludingOfNumber(for password: String) -> Bool {
        let email = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = ".*[0-9].*"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func checkIncludingOfEnglish(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = ".*[a-zA-Z].*"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    static func checkIncludingOfCharacters(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = ".*[^a-zA-Z0-9\\, \"].*"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    static func isValidUsername(for username: String) -> Bool {
        let username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let usernameRegEx = "^[a-zA-Z0-9]{4,14}$"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        return usernamePred.evaluate(with: username)
    }
//    
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
        // [A-Z0-9a-z._%+-]은 영어 대문자 소문자 특수문자 모두 가능하다는 뜻
        // +@ 는 사이에 무조건 @가 있어야 한다는 뜻
        // @뒤에는 [A-Za-z0-9.-] 대문자 소문자 숫자 .-
        // .이 온 이후 [A-Za-z]는 영어 대문자 소문자
        // {2,64}는 2~64글자만 허용
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
//    
    static func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9\\, \"]).{8,}$"

        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
