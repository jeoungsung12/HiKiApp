//
//  AnimateDetailModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import Foundation

struct AnimateDetailModel: Decodable {
    let data: AnimateData
}

struct AnimateVideoModel: Decodable {
    let data: VideoData
}

struct VideoData: Decodable {
    let promo: [VideoPromo]
}

struct VideoPromo: Decodable {
    let trailer: VideoTrailer
}

struct VideoTrailer: Decodable {
    let embed_url: String?
    let url: String?
}

struct AnimateCharacterModel: Decodable {
    let data: [CharacterData]
}

struct CharacterData: Decodable {
    let character: CharacterEntry
}

struct CharacterEntry: Decodable {
    let name: String?
    let images: CharacterImage?
}

struct CharacterImage: Decodable {
    let jpg: CharacterJPG
}

struct CharacterJPG: Decodable {
    let image_url: String
}
