//
//  SearchModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

struct SearchModel: Decodable {
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    //TODO: - 옵셔널 처리
    let id: Int
    let title: String
    let genre_ids: [Int]
    let overview: String
    let poster_path: String?
    let release_date: String
    let vote_average: Double
    let backdrop_path: String?
    
    var genreString: [String] {
        get {
            var genre: [String] = []
            for type in genre_ids {
                let filter = GenreTypes.allCases.filter { $0.rawValue == type }
                genre.append(filter[0].title)
            }
            return genre
        }
    }
    
    //TODO: - 수정
    var summaryInfo: [SummaryInfo] {
        get {
            let calendar = SummaryInfo(image: UIImage(systemName: "calendar"), text: self.release_date)
            let star = SummaryInfo(image: UIImage(systemName: "star"), text: self.vote_average.formatted())
            var typeString = ""
            for (index, type) in genreString.enumerated() {
                if index > 0 {
                    typeString += ", "
                }
                typeString += type
            }
            let film = SummaryInfo(image: UIImage(systemName: "film.fill"), text: typeString)
            return [calendar, star, film]
        }
    }
}

struct SearchResponse {
    var searchPage: Int
    var searchText: String
    var searchPhase: SearchPhase
    var searchResult: [SearchResult]
}

struct SummaryInfo {
    let image: UIImage?
    let text: String
}
