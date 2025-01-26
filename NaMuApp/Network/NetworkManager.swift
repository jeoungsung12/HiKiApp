//
//  NetworkManager.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func getData<T: Decodable>(_ api: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(api.endpoint, method: api.method, parameters: api.parmas, encoding: URLEncoding.queryString, headers: api.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
//                print(response.debugDescription)
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    //TODO: - 에러 처리
                    completion(.failure(error))
                }
            }
    }
    
}
