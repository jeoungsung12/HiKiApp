//
//  HomeModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

enum HomeSection: Hashable {
    case header
    case semiHeader(title: String)
    case middle(title: String)
    case semiFooter(title: String)
    case footer(title: String)
    
    var title: String {
        switch self {
        case .header:
            ""
        case .semiHeader:
            "이런 애니 어때요?"
        case .middle:
            "TV방영 애니"
        case .semiFooter:
            "OTT방영 애니"
        case .footer:
            "TV특별방영 애니"
        }
    }
}

enum HomeItem: Hashable {
    case poster(ItemModel)
    case recommand(ItemModel)
    case tvList(ItemModel)
    case onaList(ItemModel)
    case special(ItemModel)
}

struct ItemModel: Hashable {
    let id: Int
    let title: String
    let synopsis: String?
    let image: String
}
