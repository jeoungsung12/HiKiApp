//
//  NickName.swift
//  HiKiApp
//
//  Created by 정성윤 on 2/21/25.
//

import Foundation

struct NickName {
    enum NickNameType: String {
        case nilText = ""
        case success = "This is a nickname you can use."
        case notCount = "Please set it to at least 2 characters but less than 15 characters."
        case notSpecial = "Nickname cannot contain @, #, $, or %"
        case notNumeric = "Nicknames cannot contain numbers"
    }
    
    func checkNickName(_ text: String?) -> NickNameType {
        guard let text, !text.isEmpty else { return .nilText }
        if ((text.count < 2) || (text.count >= 15)) {
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
