//
//  SearchModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation

struct SearchModel: Decodable {
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let id: Int
    let title: String
    let genre_ids: [Int]
    let overview: String
    let poster_path: String
    let release_date: String
    let vote_average: Double
    let backdrop_path: String
}

struct SearchResponse {
    let searchPage: Int
    let searchText: String
}
