//
//  MbtiType.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation


enum MbtiType: CaseIterable {
    case IE
    case NS
    case FT
    case PJ
    
    func type(_ valid: Bool) -> String {
        switch self {
        case .IE:
            return !valid ? "I" : "E"
        case .NS:
            return !valid ? "N" : "S"
        case .FT:
            return !valid ? "F" : "T"
        case .PJ:
            return !valid ? "P" : "J"
        }
    }
}
