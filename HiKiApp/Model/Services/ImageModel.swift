//
//  ImageModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import Foundation

struct ImageModel: Decodable {
    let id: Int
    let backdrops: [ImageDetailModel]
    let posters: [ImageDetailModel]
}

struct ImageDetailModel: Decodable {
    let file_path: String
}
