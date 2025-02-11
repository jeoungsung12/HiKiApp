//
//  ProfileMBTIViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation
import UIKit

final class ProfileMBTIViewModel: ViewModelType {
    
    enum MbtiType: CaseIterable {
        case IE
        case NS
        case FT
        case PJ
    }
    
    let mbti = ProfileMBTIViewModel.MbtiType.allCases
    var tapped: (()->Void)?
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
    func checkMBTI(_ bools: [Bool?]) -> String? {
        var returnString = ""
        for (index, bool) in bools.enumerated() {
            guard let valid = bool else { return nil }
            switch MbtiType.allCases[index] {
            case .IE:
                returnString += (valid ? "E" : "I")
            case .NS:
                returnString += (valid ? "S" : "N")
            case .FT:
                returnString += (valid ? "T" : "F")
            case .PJ:
                returnString += (valid ? "J" : "P")
            }
        }
        return returnString
    }
}

extension ProfileMBTIViewModel {
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
