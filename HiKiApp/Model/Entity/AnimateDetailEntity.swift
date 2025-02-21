//
//  AnimateDetailEntity.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation

struct AnimateDetailEntity {
    let id: Int
    let title: String
    let synopsis: String
    let score: Double
    let rank: Int?
    let imageURL: String
    let trailerURL: String?
    let genres: [String]
}

extension AnimateDetailResponseDTO {
    func toEntity() -> AnimateDetailEntity {
        return AnimateDetailEntity(
            id: data.mal_id,
            title: data.title,
            synopsis: data.synopsis ?? "정보 준비 중입니다 ⚠️",
            score: data.score ?? 0.0,
            rank: data.rank,
            imageURL: data.images.jpg.image_url,
            trailerURL: data.trailer.embed_url,
            genres: data.genres?.map { $0.name } ?? []
        )
    }
}
