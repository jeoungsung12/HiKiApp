//
//  AnimateModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/6/25.
//

import Foundation

struct AnimateModel: Decodable, Hashable {
    let data: [AnimateData]
}

struct AnimateData: Decodable, Hashable {
    let mal_id: Int
    let url: String
    let images: AnimateImages
    let title: String
    let type: String?
    let synopsis: String?
}

struct AnimateImages: Decodable, Hashable {
    let jpg: AnimateJpg
}

struct AnimateJpg: Decodable, Hashable {
    let image_url: String
    let small_image_url: String
    let large_image_url: String
}
