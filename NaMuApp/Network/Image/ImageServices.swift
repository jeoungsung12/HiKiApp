//
//  ImageServices.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/26/25.
//

import Foundation

final class ImageServices {
    
    func getImage(_ id: Int, completion: @escaping (Result<ImageModel,Error>) -> Void) {
        NetworkManager.shared.getData(.image(id: id)) { (response: Result<ImageModel,Error>) in
            switch response {
            case let .success(data):
                completion(.success(data))
            case  let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
}
