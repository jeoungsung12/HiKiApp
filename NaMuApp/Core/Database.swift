//
//  Database.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import UIKit

//TODO: - 제네릭으로 바꿀수있지 않을까?
final class Database {
    static let shared = Database()
    
    private init() { }
    
    private let ud = UserDefaults.standard
    private enum Key: String {
        case isUser = "isUser"
        case userInfo = "userInfo"
        case heartList = "heartList"
        case recentSearch = "recentSearch"
    }
    
    private func get<T>(_ key: Key, binding: T) -> T {
        return ud.value(forKey: key.rawValue) as? T ?? binding
    }
    
    private func set<T>(_ key: Key, value: T) {
        ud.setValue(value, forKey: key.rawValue)
    }
    
    var isUser: Bool {
        get {
            return self.get(.isUser, binding: false)
        }
        set {
            self.set(.isUser, value: newValue)
        }
    }
    
    var userInfo: [String] {
        get {
            guard var userInfo = self.get(.userInfo, binding: []) as? [String] else { return [] }
            let heartList = self.heartList
            if userInfo.count > 1 { userInfo[2] = heartList.count.formatted() }
            return userInfo
        }
        set {
            self.set(.userInfo, value: newValue)
        }
    }
    
    var heartList: [String] {
        get {
            return self.get(.heartList, binding: [])
        }
        set {
            self.set(.heartList, value: newValue)
        }
    }
    
    var recentSearch: [String] {
        get {
            return self.get(.recentSearch, binding: [])
        }
        set {
            self.set(.recentSearch, value: newValue)
        }
    }
    
}

extension Database {
    
    func removeAll(_ model: String) {
        print(#function)
        UserDefaults.standard.removeObject(forKey: model)
    }
    
    func removeUserInfo() {
        print(#function)
        self.isUser = false
        removeAll(Key.userInfo.rawValue)
        removeAll(Key.heartList.rawValue)
        removeAll(Key.recentSearch.rawValue)
    }
    
    func removeHeartButton(_ remove: String) {
        print(#function)
        self.heartList = heartList.filter { $0 != remove }
    }
    
    func removeRecentSearch(_ remove: String) {
        print(#function)
        self.recentSearch = recentSearch.filter { $0 != remove }
    }
    
    func getUser() -> UserInfo {
        print(#function)
        return UserInfo(nickname: self.userInfo[0], profile: UIImage(named: self.userInfo[1]), movie: self.userInfo[2], date: self.userInfo[3])
    }
    
}
