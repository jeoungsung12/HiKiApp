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
            dateFormatter.dateFormat = "yy.MM.dd 가입"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: Date())
        }
    }
    
    static func stringToDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yy년 MM월 dd일"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
}
