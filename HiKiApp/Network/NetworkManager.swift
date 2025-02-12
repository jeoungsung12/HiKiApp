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
    
    func getData<T: Decodable, U: Router>(_ api: U, completion: @escaping (Result<T, NetworkError.CustomError>) -> Void) {
//        print(api.endpoint)
        AF.request(api)
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
//                dump(response.debugDescription)
//                print(response.debugDescription)
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
