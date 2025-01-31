//
//  GenreTypes.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import Foundation

enum GenreLocation {
    case search
    case detail
}

enum GenreTypes: Int, CaseIterable {
    case action = 28
    case animation = 16
    case crime = 80
    case drama = 18
    case fantasy = 14
    case horror = 27
    case mystery = 9648
    case sf = 878
    case thriller = 53
    case western = 37
    case adventure = 12
    case comedy = 35
    case documentary = 99
    case family = 10751
    case history = 36
    case music = 10402
    case romance = 10749
    case tvMovie = 10770
    case war = 10752
    
    var title: String {
        switch self {
        case .action:
            "액션"
        case .animation:
            "애니메이션"
        case .crime:
            "범죄"
        case .drama:
            "드라마"
        case .fantasy:
            "판타지"
        case .horror:
            "공포"
        case .mystery:
            "미스터리"
        case .sf:
            "SF"
        case .thriller:
            "스릴러"
        case .western:
            "서부"
        case .adventure:
            "모험"
        case .comedy:
            "코미디"
        case .documentary:
            "다큐멘터리"
        case .family:
            "가족"
        case .history:
            "역사"
        case .music:
            "음악"
        case .romance:
            "로맨스"
        case .tvMovie:
            "TV 영화"
        case .war:
            "전쟁"
        }
    }
}
