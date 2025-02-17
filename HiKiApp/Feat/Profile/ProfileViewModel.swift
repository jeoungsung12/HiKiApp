//
//  ProfileViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/5/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    private let db = DataBase.shared
    private var disposeBag = DisposeBag()
    
    struct Input {
        let configureViewTrigger: PublishSubject<Void>
        let nameTextFieldTrigger: PublishSubject<String?>
        let successButtonTrigger: PublishSubject<ProfileSuccessButtonRequest>
        let buttonEnabledTrigger: PublishSubject<ProfileSuccessButtonRequest>
    }
    
    struct Output {
        let buttonEnabledResult: PublishSubject<Bool?> = PublishSubject()
        let successButtonResult: PublishSubject<Bool?> = PublishSubject()
        let nameTextFieldResult: PublishSubject<String?> = PublishSubject()
        //TODO: ProfileViewResult
        let configureViewResult: PublishSubject<[String?]> = PublishSubject()
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
    
    private func validateText(_ success: ProfileSuccessButtonResponse,_ complete: Bool) -> Bool? {
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
    
    
    private func handleSuccessButtonTap(profileImage: UIImage?, name: String?, description: String?) -> ProfileSuccessButtonResponse? {
        let profileData = ProfileSuccessButtonResponse(
            profileImage: profileImage,
            name: name,
            description: description
        )
        return profileData
    }
}


extension ProfileViewModel {
    
    struct NickName {
        
        enum NickNameType: String {
            case nilText = ""
            case success = "사용할 수 있는 닉네임이에요"
            case notCount = "2글자 이상 10글자 미만으로 설정해 주세요"
            case notSpecial = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            case notNumeric = "닉네임에 숫자는 포함할 수 없어요"
        }
        
        func checkNickName(_ text: String?) -> NickNameType {
            guard let text, !text.isEmpty else { return .nilText }
            if ((text.count < 2) || (text.count >= 10)) {
                return NickNameType.notCount
            }
            
            if (text.rangeOfCharacter(from: CharacterSet(charactersIn: "@#$%")) != nil) {
                return NickNameType.notSpecial
            }
            
            if (text.rangeOfCharacter(from: .decimalDigits) != nil) {
                return NickNameType.notNumeric
            }
            
            return NickNameType.success
        }
    }
}
