//
//  Database.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

final class Database {
    static let shared = Database()
    
    private init() { }
    //TODO: - 제네릭 타입으로 바꿀수 있지 않을까?
    
    var isUser: Bool {
        get {
            guard let isUser = UserDefaults.standard.value(forKey: "isUser") as? Bool else { return false }
            return isUser
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isUser")
        }
    }
    
    var userInfo: [String] {
        get {
            guard let userInfo = UserDefaults.standard.value(forKey: "userInfo") as? [String] else { return [] }
            return userInfo
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userInfo")
        }
    }
    
    var recentSearch: [String] {
        get {
            guard let recentSearch = UserDefaults.standard.value(forKey: "recentSearch") as? [String] else { return [] }
            return recentSearch
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "recentSearch")
        }
    }
    
}

extension Database {
    
    func removeAll(_ model: String) {
        UserDefaults.standard.removeObject(forKey: model)
    }
    
    func removeUserInfo() {
        self.isUser = false
        UserDefaults.standard.removeObject(forKey: "userInfo")
    }
    
    func removeRecentSearch(_ remove: String) -> [String] {
        guard var recentSearch = UserDefaults.standard.value(forKey: "recentSearch") as? [String],
              let index = recentSearch.lastIndex(where: { $0 == remove }) else { return [] }
        recentSearch.remove(at: index)
        return recentSearch
    }
    
    func getUser() -> UserInfo {
        return UserInfo(nickname: self.userInfo[0], profile: UIImage(named: self.userInfo[1]), movie: self.userInfo[2], date: self.userInfo[3])
    }
    
}
