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
    private let db = UserDefaultManager.shared
    private(set) var profileData = ProfileData.allCases
    private var disposeBag = DisposeBag()
    
    enum MyPageCategoryType: String, CaseIterable {
        case aniBox = "애니 보관함"
        case reviewBox = "리뷰 보관함"
        case profile = "프로필 수정"
        
        var image: String {
            switch self {
            case .aniBox:
                "cube.box"
            case .reviewBox:
                "bubble.and.pencil.rtl"
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
        let profileTrigger: PublishSubject<Void>
        let listBtnTrigger: PublishRelay<MyPageButtonType>
        let categoryBtnTrigger: PublishRelay<MyPageCategoryType>
    }
    
    struct Output {
        let profileResult: BehaviorRelay<UserInfo>
        let listBtnResult: PublishRelay<MyPageButtonType>
        let categoryBtnResult: PublishRelay<MyPageCategoryType>
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
        let profileResult = BehaviorRelay(value: db.userInfo)
        input.profileTrigger
            .bind(with: self) { owner, _ in
                profileResult.accept(owner.db.userInfo)
            }
            .disposed(by: disposeBag)
        
        let categoryResult = PublishRelay<MyPageCategoryType>()
        input.categoryBtnTrigger
            .bind { value in
                categoryResult.accept(value)
            }.disposed(by: disposeBag)
        
        let btnResult = PublishRelay<MyPageButtonType>()
        input.listBtnTrigger
            .bind { value in
                btnResult.accept(value)
            }.disposed(by: disposeBag)
        
        return Output(
            profileResult: profileResult,
            listBtnResult: btnResult,
            categoryBtnResult: categoryResult)
    }
    
    func removeUserInfo() {
        db.removeUserDefault(.userInfo)
        db.removeUserDefault(.userReview)
        db.removeUserDefault(.recentSearch)
    }
    
    func getSaveAnime() -> String {
        return db.userInfo.saveAnimateID.count.formatted() + "개 보관중"
    }
    
}
