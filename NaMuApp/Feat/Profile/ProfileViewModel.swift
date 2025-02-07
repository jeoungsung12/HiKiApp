//
//  ProfileViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/5/25.
//

import Foundation

final class ProfileViewModel: ViewModelType {
    private let db = Database.shared
    
    struct Input {
        let configureViewTrigger: Observable<Void>
        let successButtonTrigger: Observable<ProfileSuccessButton>
        let profileButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let successButtonResult: Observable<Bool?> = Observable(nil)
        let profileButtonResult: Observable<Void> = Observable(())
        let configureViewResult: Observable<[String]> = Observable(([]))
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension ProfileViewModel {
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.configureViewTrigger.bind { [weak self] _ in
            if let userInfo = self?.db.userInfo {
                output.configureViewResult.value = userInfo
            }
        }
        
        input.successButtonTrigger.lazyBind { [weak self] success in
            output.successButtonResult.value = self?.validateText(success)
        }
        
        input.profileButtonTrigger.lazyBind { _ in
            output.profileButtonResult.value = ()
        }
        
        return output
    }
    
    private func validateText(_ success: ProfileSuccessButton) -> Bool? {
        if let nicknameLabel = success.textFields[0], let descriptionLabel = success.textFields[1],
           descriptionLabel == NickName.NickNameType.success.rawValue {
            db.isUser = true
            db.userInfo = [nicknameLabel, .checkProfileImage(success.profileImage), "0", .currentDate]
            return true
        } else {
            return false
        }
    }
    
}
