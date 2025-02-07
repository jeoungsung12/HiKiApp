//
//  ProfileMBTIViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation

final class ProfileMBTIViewModel {
    let mbti: [String] = ["E", "S", "T", "J", "I", "N", "F", "P"]
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}
