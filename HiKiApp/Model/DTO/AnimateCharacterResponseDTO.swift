//
//  AnimateCharacterResponseDTO.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation

struct AnimateCharacterResponseDTO: Decodable {
    let data: [CharacterDataDTO]
}

struct CharacterDataDTO: Decodable {
    let character: CharacterEntryDTO
    
    struct CharacterEntryDTO: Decodable {
        let name: String?
        let images: CharacterImageDTO?
    }
    
    struct CharacterImageDTO: Decodable {
        let jpg: CharacterJPGDTO
    }
    
    struct CharacterJPGDTO: Decodable {
        let image_url: String
    }
}
