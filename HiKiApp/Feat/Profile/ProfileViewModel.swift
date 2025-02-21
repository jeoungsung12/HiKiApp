//
//  ProfileViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/5/25.
//

import UIKit
import RxSwift
import RxCocoa

struct ProfileButton {
    var profileImage: UIImage?
    var name: String?
    var description: String?
}

final class ProfileViewModel: BaseViewModel {
    private let db = DataBase.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let configureViewTrigger: PublishSubject<Void>
        let nameTextFieldTrigger: PublishSubject<String?>
        let successButtonTrigger: PublishSubject<ProfileButton>
        let buttonEnabledTrigger: PublishSubject<ProfileButton>
    }
    
    struct Output {
        let buttonEnabledResult: PublishSubject<Bool?> = PublishSubject()
        let successButtonResult: PublishSubject<Bool?> = PublishSubject()
        let nameTextFieldResult: PublishSubject<String?> = PublishSubject()
        //TODO: ProfileViewResult - Object
        let configureViewResult: BehaviorSubject<[String?]> = BehaviorSubject(value: [])
    }
    
    init() {
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
    
}

extension ProfileViewModel {
    
    func transform(_ input: Input) -> Output {
        let output = Output()
        
        input.configureViewTrigger
            .bind(with: self) { owner, _ in
                output.configureViewResult.onNext(owner.db.userInfo)
            }.disposed(by: disposeBag)
        
        input.successButtonTrigger
            .bind(with: self) { owner, success in
                if let value = owner.handleSuccessButtonTap(profileImage: success.profileImage, name: success.name, description: success.description) {
                    output.successButtonResult.onNext(owner.validateText(value, true))
                }
            }.disposed(by: disposeBag)
        
        input.nameTextFieldTrigger
            .bind(with: self) { owner, text in
                let nicknameText = NickName().checkNickName(text)
                output.nameTextFieldResult.onNext(nicknameText.rawValue)
            }.disposed(by: disposeBag)
        
        input.buttonEnabledTrigger
            .bind(with: self) { owner, enable in
                if let value = owner.handleSuccessButtonTap(profileImage: enable.profileImage, name: enable.name, description: enable.description)
                {
                    output.buttonEnabledResult.onNext(owner.validateText(value, false))
                }
            }.disposed(by: disposeBag)
        
        return output
    }
    
}

extension ProfileViewModel {
    
    private func validateText(_ success: ProfileButton,_ complete: Bool) -> Bool? {
        if let nicknameLabel = success.name, let descriptionLabel = success.description,
           descriptionLabel == NickName.NickNameType.success.rawValue {
            
            if complete {
                db.isUser = true
                //TODO: Object
                db.userInfo = [nicknameLabel, .checkProfileImage(success.profileImage), "0", .currentDate]
            }
            return true
        } else {
            return false
        }
    }
    
    
    private func handleSuccessButtonTap(profileImage: UIImage?, name: String?, description: String?) -> ProfileButton? {
        let profileData = ProfileButton(
            profileImage: profileImage,
            name: name,
            description: description
        )
        return profileData
    }
}
