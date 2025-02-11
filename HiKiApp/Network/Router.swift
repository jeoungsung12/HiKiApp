//
//  Router.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/12/25.
//

import Foundation
import Alamofire

enum RouterError: Error {
    case invalidURL
    case encodingError
}

protocol Router: URLRequestConvertible {
    var endpoint: String { get }
    var path: String { get }
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var params: Parameters { get }
    var encoding: ParameterEncoding? { get }
}

extension Router {
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw RouterError.invalidURL
        }
        var request = URLRequest(url: url)
        request.method = method
        request.headers = (headers)
        
        if let encoding = encoding {
            do {
                return try encoding.encode(
                    request,
                    with: params)
            } catch {
                throw RouterError.encodingError
            }
        }
        return request
    }
}
