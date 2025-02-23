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
            "How about like this?👀"
        case .middle:
            "Rating 8 or higher 🌟"
        case .semiFooter:
            "Aired on TV"
        case .footer:
            "Original Net Animation"
        }
    }
}

enum HomeItem: Hashable {
    case poster(ItemModel)
    case recommand(ItemModel)
    case rank(ItemModel)
    case tvList(ItemModel)
    case onaList(ItemModel)
}

struct ItemModel: Hashable {
    let id: Int
    let title: String?
    let synopsis: String?
    let image: String
    let star: Double
    let genre: [String]?
}
