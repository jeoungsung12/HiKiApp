//
//  AnimeType.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

enum AnimateType: CaseIterable {
    case airing
    case bypopularity
    case favorite
    case age
    case upcoming
    
    var filter: String {
        switch self {
        case .airing,
                .age:
            "airing"
        case .upcoming:
            "upcoming"
        case .bypopularity:
            "bypopularity"
        case .favorite:
            "favorite"
        }
    }
    
    var title: String {
        switch self {
        case .airing:
            "방영"
        case .upcoming:
            "방영예정"
        case .bypopularity:
            "최신인기"
        case .favorite:
            "즐겨보는"
        case .age:
            "연령별"
        }
    }
}
