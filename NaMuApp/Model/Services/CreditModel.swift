//
//  CreditModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import Foundation

struct CreditModel: Decodable {
    let id: Int
    let cast: [CreditCast]?
}

struct CreditCast: Decodable {
    let name: String
    let original_name: String
    let character: String
    let profile_path: String
}
