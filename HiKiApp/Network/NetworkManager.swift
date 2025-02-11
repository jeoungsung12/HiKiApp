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
    
    //TODO: - RouterPattern
    private init() { }
    
    func getData<T: Decodable>(_ api: APIEndpoint, completion: @escaping (Result<T, NetworkError.CustomError>) -> Void) {
//        print(api.endpoint)
        AF.request(api.endpoint, method: api.method, parameters: api.parmas, encoding: URLEncoding.queryString, headers: api.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
//                dump(response.debugDescription)
                let statucCode = NetworkError().checkErrorType(response.response?.statusCode)
                switch response.result {
                case let .success(data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(statucCode))
                }
            }
    }
    
}
