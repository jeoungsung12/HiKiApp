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
}
