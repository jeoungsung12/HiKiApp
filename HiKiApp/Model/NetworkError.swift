//
//  NetworkError.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation

struct NetworkError {
    static let noImage: String = "Information is being prepared..⚠️"
    
    enum CustomError: Int, Error, CaseIterable, LocalizedError {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFount = 404
        case server = 500
        case network
        
        var errorDescription: String? {
            switch self {
            case .badRequest:
                "This is an invalid request"
            case .unauthorized:
                "An authentication error occurred"
            case .forbidden:
                "Access is denied"
            case .notFount:
                "Page not found"
            case .server:
                "The connection to the server is not smooth."
            case .network:
                "The network connection is poor."
            }
        }
    }
    
    func checkErrorType(_ error: Int?) -> CustomError {
        guard let error = error, let type = CustomError.allCases.filter({ $0.rawValue == error }).first else { return .network }
        return type
    }
}
