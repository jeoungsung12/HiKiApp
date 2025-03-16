//
//  Database.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

struct UserInfo: Codable {
    var nickname: String
    var profile: String?
    var saveAnimateID: [Int]
    var date: String
}

struct UserReview: Codable, Equatable {
    var title: String
    var image: String
    var date: String
    var review: String
    var answer: String
    var reviewValue: Double
}

@propertyWrapper
struct UserDefaultStruct<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                return defaultValue
            }
            return decoded
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
}

final class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() { }
    
    enum Key: String {
        case recentSearch
        case userInfo
        case userReview
    }
    
    @UserDefaultStruct(key: Key.recentSearch.rawValue, defaultValue: [""])
    var recentSearch
    
    @UserDefaultStruct(
        key: Key.userInfo.rawValue,
        defaultValue: UserInfo(
            nickname: "",
            profile: nil,
            saveAnimateID: [],
            date: ""
        )
    )
    var userInfo
    
    @UserDefaultStruct(
        key: Key.userReview.rawValue,
        defaultValue: [UserReview]()
    )
    var userReview
    
    func removeUserDefault(_ key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
}
