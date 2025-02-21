//
//  AnimateVideoEntity.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation

struct AnimateVideoEntity {
    let trailerURL: String?
}

extension AnimateVideoResponseDTO {
    func toEntity() -> [AnimateVideoEntity] {
        return data.promo.map {
            AnimateVideoEntity(trailerURL: $0.trailer.embed_url)
        }
    }
}
