//
//  Core.swift
//  AdoptMe
//
//  Created by Quoc Thuan Truong on 12/5/20.
//

import Foundation

class Core {
    static let shared = Core()
    var isLogin = false
    var keyName = ""
    
    func isFirstLauchApp() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isFirstLauchApp")
    }
    
    func setIsNotFirstLauchApp() {
        UserDefaults.standard.setValue(true, forKey: "isFirstLauchApp")
    }
    
    func setIsFirstLauchApp() {
        UserDefaults.standard.setValue(false, forKey: "isFirstLauchApp")
    }

    func isRememberMe() -> Bool {
        return UserDefaults.standard.bool(forKey: "IsUserLogin")
    }
    
    //TO DO: add code here
    func isUserLogin() -> Bool {
        return isLogin
    }
    
    func setIsUserLogin(_ isLogin: Bool) {
        self.isLogin = isLogin
    }
    
    func setToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func setKeyName(_ keyName: String) {
        UserDefaults.standard.setValue(keyName, forKey: "keyName")
    }
    
    func getKeyName() -> String {
        return UserDefaults.standard.string(forKey: "keyName") ?? ""
    }
}
