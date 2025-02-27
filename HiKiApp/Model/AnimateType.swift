//
//  AnimeType.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

enum AnimateType: String, CaseIterable {
    case Airing
    case Popular
    case Favorite
    case Random
    
    var filter: String {
        switch self {
        case .Airing:
            "airing"
        case .Random:
            "upcoming"
        case .Popular:
            "bypopularity"
        case .Favorite:
            "favorite"
        }
    }
}
