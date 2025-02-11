//
//  MyPageViewModel.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/11/25.
//

import Foundation

final class MyPageViewModel: ViewModelType {
    private let db = DataBase.shared
    
    enum MyPageCategoryType: String, CaseIterable {
        case aniBox = "애니 보관함"
        case watchBox = "하이라이트"
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
        let profileTrigger: Observable<Void>
        let categoryBtnTrigger: Observable<MyPageCategoryType?>
    }
    
    struct Output {
        let profileResult: Observable<UserInfo?> = Observable(nil)
        let categoryBtnResult: Observable<MyPageCategoryType?> = Observable(nil)
    }

    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension MyPageViewModel {
    
    func transform(input: Input) -> Output {
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
