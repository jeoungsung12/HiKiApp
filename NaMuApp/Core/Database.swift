//
//  Database.swift
//  NaMuApp
//
//  Created by 정성윤 on 1/25/25.
//

import Foundation

final class Database {
    static let shared = Database()
    
    private init() { }
    
    var isUser: Bool {
        get {
            guard let isUser = UserDefaults.standard.value(forKey: "isUser") as? Bool else { return false }
            return isUser
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isUser")
        }
    }
    
    var userInfo: [String]? {
        get {
            guard let userInfo = UserDefaults.standard.value(forKey: "userInfo") as? [String] else { return nil }
            return userInfo
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userInfo")
        }
    }
    
    
}
