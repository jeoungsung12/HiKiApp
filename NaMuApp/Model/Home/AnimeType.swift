//
//  AnimeType.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

enum AnimeType: String {
    case airing
    case upcoming
    case bypopularity
    case favorite
    
    var filter: String {
        switch self {
        case .airing:
            "airing"
        case .upcoming:
            "upcoming"
        case .bypopularity:
            "bypopularity"
        case .favorite:
            "favorite"
        }
    }
}
