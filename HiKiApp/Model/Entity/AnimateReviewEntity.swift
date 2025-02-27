//
//  AnimateReviewEntity.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation
struct AnimateReviewEntity {
    let score: Int
    let date: String
    let review: String
    let isSpoiler: Bool
    let username: String
    let animeTitle: String
    let animeId: Int
    let imageUrl: String
}

extension ReviewDataDTO {
    func toEntity() -> AnimateReviewEntity {
        return AnimateReviewEntity(
            score: self.score,
            date: self.date,
            review: self.review,
            isSpoiler: self.is_spoiler,
            username: self.user.username,
            animeTitle: self.entry.title,
            animeId: self.entry.mal_id,
            imageUrl: self.entry.images.jpg.image_url
        )
    }
}
