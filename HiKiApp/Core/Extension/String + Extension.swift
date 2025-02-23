//
//  String + Extension.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

extension String {
    
    static func checkProfileImage(_ image: UIImage?) -> String {
        guard let image = image else { return "" }
        for imageString in ProfileData.allCases {
            if UIImage(named: imageString.rawValue) == image {
                return imageString.rawValue
            }
        }
        return ""
    }
    
    static var currentDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd Join"
//            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone.current
            return dateFormatter.string(from: Date())
        }
    }
    
    static func stringToDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
//        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy.MM.dd"
//            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
}
