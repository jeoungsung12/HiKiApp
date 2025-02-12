//
//  AnimateReviewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import Foundation

struct AnimateReviewModel: Decodable {
    let data: [ReviewData]
}

struct ReviewData: Decodable {
    let score: Int
    let date: String
    let review: String
    let is_spoiler: Bool
    let user: ReviewUser
    let entry: ReviewEntry
}

struct ReviewUser: Decodable {
    let username: String
}

struct ReviewEntry: Decodable {
    let mal_id: Int
    let title: String
    let images: AnimateImages
}
