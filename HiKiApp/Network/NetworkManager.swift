//
//  NetworkManager.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func getData<T: Decodable, U: Router>(_ api: U) -> Observable<T> {
//        print(api.endpoint)
        return Observable<T>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: T.self) { response in
//                    dump(response.debugDescription)
                    if U.self == ReviewRouter.self {
                        print(response.debugDescription)
                    }
                    let statucCode = NetworkError().checkErrorType(response.response?.statusCode)
                    switch response.result {
                    case let .success(data):
                        observer.onNext((data))
                        observer.onCompleted()
                    case .failure:
                        observer.onError(statucCode)
                    }
                }
            return Disposables.create()
        }
    }
    
}
