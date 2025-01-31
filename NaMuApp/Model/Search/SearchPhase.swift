//
//  SearchPhase.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/27/25.
//

import Foundation

enum SearchPhase {
    case success
    case notRequest
    case notFound
    case endPage
    
    var message: String {
        switch self {
        case .success:
            ""
        case .notRequest:
            ""
        case .notFound:
            "원하는 검색결과를 찾지 못했습니다"
        case .endPage:
            "마지막 페이지 입니다"
        }
    }
}
