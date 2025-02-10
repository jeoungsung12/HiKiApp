//
//  WatchModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/10/25.
//

import Foundation

struct WatchModel: Decodable {
    let data: WatchData?
}

struct WatchData: Decodable {
    let promo: [WatchMusicVideos]
}

struct WatchMusicVideos: Decodable {
    let title: String
    let trailer: WatchVideo
}

struct WatchVideo: Decodable {
    let youtube_id: String?
    let url: String?
}
