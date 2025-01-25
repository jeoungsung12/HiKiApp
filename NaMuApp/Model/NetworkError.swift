//
//  NetworkError.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation

struct NetworkError {
    enum errorType: Int, Error, LocalizedError {
        case clientError
        
        case network
    }
    
    
}
