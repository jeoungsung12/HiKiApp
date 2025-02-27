//
//  AnimateCharacterEntity.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation

struct AnimateCharacterEntity {
    let names: String
    let images: String?
    
}

extension AnimateCharacterResponseDTO {
    func toEntity() -> [AnimateCharacterEntity] {
        return data.map {
            return AnimateCharacterEntity(names: $0.character.name ?? "이름 없음", images: $0.character.images?.jpg.image_url )
        }
    }
}
