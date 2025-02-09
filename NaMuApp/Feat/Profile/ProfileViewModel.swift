//
//  ProfileViewModel.swift
//  NaMuApp
//
//  Created by 정성윤 on 2/5/25.
//

import Foundation
import UIKit

final class ProfileViewModel: ViewModelType {
    private let db = Database.shared
    
    struct Input {
        let configureViewTrigger: Observable<Void>
        let profileButtonTrigger: Observable<Void>
        let nameTextFieldTrigger: Observable<String?>
        let successButtonTrigger: Observable<ProfileSuccessButton>
        let buttonEnabledTrigger: Observable<ProfileSuccessButton>
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
            output.successButtonResult.value = self?.validateText(success, true)
        }
        
        input.profileButtonTrigger.lazyBind { _ in
            output.profileButtonResult.value = ()
        }
        
        input.nameTextFieldTrigger.lazyBind { text in
            let nicknameText = NickName().checkNickName(text)
            output.nameTextFieldResult.value = nicknameText.rawValue
        }
        
        input.buttonEnabledTrigger.lazyBind { [weak self] enable in
            output.buttonEnabledResult.value = self?.validateText(enable, false)
        }
        
        return output
    }
    
    private func validateText(_ success: ProfileSuccessButton,_ complete: Bool) -> Bool? {
        //TODO: - 인덱스 접근하지 말기
        if let nicknameLabel = success.textFields[0], let descriptionLabel = success.textFields[1],
           descriptionLabel == NickName.NickNameType.success.rawValue, let mbti = checkMBTI(success.mbtiBools) {
            
            if complete {
                db.isUser = true
                db.userInfo = [nicknameLabel, .checkProfileImage(success.profileImage), "0", .currentDate, mbti]
            }
            return true
        } else {
            return false
        }
    }
    
    private func checkMBTI(_ bools: [Bool?]) -> String? {
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


extension ProfileViewModel {
    
    struct ProfileSuccessButton {
        var profileImage: UIImage?
        var textFields: [String?]
        var mbtiBools: [Bool?]
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
    
    enum MbtiType: CaseIterable {
        case IE
        case NS
        case FT
        case PJ
    }
    
}
