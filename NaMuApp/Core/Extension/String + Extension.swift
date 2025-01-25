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
}
