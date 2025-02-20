//
//  AnimateDetailModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import Foundation

struct AnimateDetailResponseDTO: Decodable {
    let data: AnimateDataDTO
}

struct AnimateVideoResponseDTO: Decodable {
    let data: VideoDataDTO
    
    struct VideoDataDTO: Decodable {
        let promo: [VideoPromoDTO]
    }
    
    struct VideoPromoDTO: Decodable {
        let trailer: VideoTrailerDTO
    }
    
    struct VideoTrailerDTO: Decodable {
        let embed_url: String?
        let url: String?
    }
}
