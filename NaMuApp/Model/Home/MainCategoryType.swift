//
//  MainCategoryType.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//
import Foundation
enum MainCategoryType: String, CaseIterable {
    case recommand = "추천"
    case airing = "방송"
    case upcoming = "예정"
    case bypopularity = "최신인기"
    case favorite = "즐겨보는"
}
