//
//  CastServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import Foundation

final class CastServices {
    
    func getCredit(_ id: Int, completion: @escaping (Result<CreditModel,Error>) -> Void) {
        NetworkManager.shared.getData(.image(id: id)) { (response: Result<CreditModel,Error>) in
            switch response {
            case let .success(data):
                completion(.success(data))
            case  let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
