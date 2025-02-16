//
//  ProfileViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/5/25.
//

import Foundation
import UIKit

final class ProfileViewModel: ViewModelType {
    private let db = DataBase.shared
    
    struct Input {
        let configureViewTrigger: Observable<Void>
        let profileButtonTrigger: Observable<Void>
        let nameTextFieldTrigger: Observable<String?>
        let successButtonTrigger: Observable<ProfileSuccessButtonRequest>
        let buttonEnabledTrigger: Observable<ProfileSuccessButtonRequest>
    }
    
    struct Output {
        let profileButtonResult: Observable<Void> = Observable(())
        let buttonEnabledResult: Observable<Bool?> = Observable(nil)
        let successButtonResult: Observable<Bool?> = Observable(nil)
        let nameTextFieldResult: Observable<String?> = Observable(nil)
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
            if let value = self?.handleSuccessButtonTap(profileImage: success.profileImage, name: success.name, description: success.description)
            {
                output.successButtonResult.value = self?.validateText(value, true)
            }
        }
        
        input.profileButtonTrigger.lazyBind { _ in
            output.profileButtonResult.value = ()
        }
        
        input.nameTextFieldTrigger.lazyBind { text in
            let nicknameText = NickName().checkNickName(text)
            output.nameTextFieldResult.value = nicknameText.rawValue
        }
        
        input.buttonEnabledTrigger.lazyBind { [weak self] enable in
            if let value = self?.handleSuccessButtonTap(profileImage: enable.profileImage, name: enable.name, description: enable.description)
            {
                output.buttonEnabledResult.value = self?.validateText(value, false)
            }
        }
        
        return output
    }
    
}

extension ProfileViewModel {
    
    private func validateText(_ success: ProfileSuccessButtonResult,_ complete: Bool) -> Bool? {
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
    
    
    private func handleSuccessButtonTap(profileImage: UIImage?, name: String?, description: String?) -> ProfileSuccessButtonResult? {
        let profileData = ProfileSuccessButtonResult(
            profileImage: profileImage,
            name: name,
            description: description
        )
        return profileData
    }
}


extension ProfileViewModel {
    
    struct ProfileSuccessButtonRequest {
        var profileImage: UIImage?
        var name: String?
        var description: String?
    }
    
    struct ProfileSuccessButtonResult {
        var profileImage: UIImage?
        var name: String?
        var description: String?
    }
    
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
