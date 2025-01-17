
import Foundation

extension String {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "KST")
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    /// 문자열 형식의 날짜를 Date 객체로 변환합니다.
       /// - Returns: Date
       func toDate() -> Date? {
           let dateFormatter = Self.dateFormatter
           guard let date = dateFormatter.date(from: self) else {
               return nil
           }
           return date
       }
    
    func toDateFromMonthDay() -> Date? {
        let dateFormatter = DateFormatter()
        let currentYear = Calendar.current.component(.year, from: Date())
        
        dateFormatter.dateFormat = "M/dd"
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.year = currentYear
        
        return Calendar.current.date(from: components)
    }
    
    func toDayofDate() -> String {
        guard let date = self.toDate() else {
            return "날짜오류"
        }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        return "\(day)"
    }
    
    func toMonthofDate() -> String {
        guard let date = self.toDate() else {
            return "날짜오류"
        }
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        return "\(month)"
    }
    
    func toYearofDate() -> String {
        guard let date = self.toDate() else {
            return "날짜오류"
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        return "\(year)"
    }
}


