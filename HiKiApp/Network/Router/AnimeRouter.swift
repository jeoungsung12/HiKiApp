//
//  AnimeRouter.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import Foundation
import Alamofire

struct AnimateRequest {
    var page: Int
    var rating: String
    var filter: String
}

enum AnimeRouter {
    case topAnime(request: AnimateRequest)
    case ranomAnime(page: Int)
    case getAnimeVideos(id: Int)
    case search(request: SearchViewModel.SearchRequest)
    case topReview(page: Int)
    case detailAnime(id: Int)
    case characters(id: Int)
    case getReview(id: Int, page: Int)
}

extension AnimeRouter: Router {
    
    var endpoint: String {
        return baseURL + path
    }
    
    var path: String {
        switch self {
        case .topAnime(let request):
            return "/top/anime?filter=\(request.filter)&sfw=true&page=\(request.page)"
        case .ranomAnime(let page):
            return "/anime?page=\(page)"
        case .getAnimeVideos(let id):
            return "/anime/\(id)/videos"
        case .search(let request):
            return "/anime?q=\(request.searchText)&page=\(request.searchPage)"
        case .topReview(let page):
            return "/top/reviews?type=anime&page=\(page)"
        case .getReview(let id, let page):
            return "/anime/\(id)/reviews?page=\(page)"
        case .detailAnime(let id):
            return "/anime/\(id)"
        case .characters(let id):
            return "/anime/\(id)/characters"
        }
    }
    
    var baseURL: String {
        return "https://api.jikan.moe/v4"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders {
        return [ "Content-Type": "application/json"]
    }
    
    var params: Parameters {
        return [:]
    }
    
    var encoding: (any ParameterEncoding)? {
        return URLEncoding.default
    }
    
    var feedbackURL: String {
        return "https://forms.gle/L1gatZ3RpQJCtm5v5"
    }
    
}
