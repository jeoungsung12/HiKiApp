//
//  AnimateDataEntity.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation
struct AnimateDataEntity: Hashable {
    let id: Int
    let title: String
    let enTitle: String?
    let type: String
    let synopsis: String
    let score: Double
    let rank: Int?
    let imageURL: String
    let trailerURL: String?
    let genres: [String]
}

extension AnimateDataDTO {
    func toEntity() -> AnimateDataEntity {
        return AnimateDataEntity(
            id: mal_id,
            title: title,
            enTitle: title_english,
            type: type ?? "",
            synopsis: synopsis ?? "정보 준비 중입니다 ⚠️",
            score: score ?? 0.0,
            rank: rank,
            imageURL: images.jpg.image_url,
            trailerURL: trailer.embed_url,
            genres: genres?.map { $0.name } ?? []
        )
    }
}
