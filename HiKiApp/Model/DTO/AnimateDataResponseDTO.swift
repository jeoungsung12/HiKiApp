//
//  AnimateModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

struct AnimateDataResponseDTO: Decodable, Hashable {
    let data: [AnimateDataDTO]
}

struct AnimateDataDTO: Decodable, Hashable {
    let mal_id: Int
    let title: String
    let type: String?
    let synopsis: String?
    let score: Double?
    let rank: Int?
    let title_english: String?
    let images: AnimateImagesDTO
    let trailer: AnimateTrailerDTO
    let genres: [AnimateGenreDTO]?
    
    struct AnimateGenreDTO: Decodable, Hashable {
        let name: String
    }

    struct AnimateTrailerDTO: Decodable, Hashable {
        let embed_url: String?
        let url: String?
        
        enum CodingKeys: CodingKey {
            case embed_url
            case url
        }
    }

    struct AnimateImagesDTO: Decodable, Hashable {
        let jpg: AnimateJpgDTO
    }

    struct AnimateJpgDTO: Decodable, Hashable {
        let image_url: String
        let small_image_url: String
        let large_image_url: String
    }
}
