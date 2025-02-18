//
//  MyPageViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/11/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPageViewModel: BaseViewModel {
    private let db = DataBase.shared
    private(set) var profileData = ProfileData.allCases
    
    enum MyPageCategoryType: String, CaseIterable {
        case aniBox = "애니 보관함"
        case watchBox = "티저 보관함"
        case profile = "프로필 수정"
        
        var image: String {
            switch self {
            case .aniBox:
                "cube.box"
            case .watchBox:
                "play.tv"
            case .profile:
                "person.text.rectangle"
            }
        }
    }
    
    enum MyPageButtonType: String, CaseIterable {
        case oftenQS = "자주 묻는 질문"
        case feedback = "피드백 보내기"
        case withdraw = "탈퇴하기"
    }
    
    struct Input {
        let profileTrigger: CustomObservable<Void>
        let categoryBtnTrigger: CustomObservable<MyPageCategoryType?>
    }
    
    struct Output {
        let profileResult: CustomObservable<UserInfo?> = CustomObservable(nil)
        let categoryBtnResult: CustomObservable<MyPageCategoryType?> = CustomObservable(nil)
    }

    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension MyPageViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.profileTrigger.bind { [weak self] _ in
            output.profileResult.value = self?.db.getUser()
        }
        
        input.categoryBtnTrigger.lazyBind { type in
            guard let type = type else { return }
            output.categoryBtnResult.value = type
        }
        
        return output
    }
    
    func removeUserInfo() {
        self.db.removeUserInfo()
    }
    
    func getUserInfo() -> String {
        return self.db.getUser().movie
    }
    
}
