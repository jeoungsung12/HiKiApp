//
//  AnimateReviewModelDTO.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import Foundation

struct AnimateReviewResponseDTO: Decodable {
    let data: [ReviewDataDTO]
}

struct ReviewDataDTO: Decodable {
    let score: Int
    let date: String
    let review: String
    let is_spoiler: Bool
    let user: ReviewUserDTO
    let entry: ReviewEntryDTO
    
    struct ReviewUserDTO: Decodable {
        let username: String
    }

    struct ReviewEntryDTO: Decodable {
        let mal_id: Int
        let title: String
        let images: AnimateDataDTO.AnimateImagesDTO
    }

}
