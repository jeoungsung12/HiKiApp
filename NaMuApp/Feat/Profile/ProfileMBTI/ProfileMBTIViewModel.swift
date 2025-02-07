//
//  ProfileMBTIViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/7/25.
//

import Foundation

final class ProfileMBTIViewModel {
    let mbti = ProfileViewModel.MbtiType.allCases
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}
