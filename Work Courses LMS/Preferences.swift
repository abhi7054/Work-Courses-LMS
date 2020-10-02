//
//  Preferences.swift
//  Work Courses LMS
//
//  Created by Arpit on 10/2/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import Foundation

struct KKeyPreferences {
    static let user = "kKeyUser"
    static let auth = "kKeyAuth"
}

class Auth: Codable {
    var authToken: String?
    var email: String?
    enum CodingKeys: String, CodingKey {
        case authToken = "authToken"
        case email = "email"
    }

    init(authToken: String?, email: String?) {
        self.authToken = authToken
        self.email = email
    }
}

class LDataStorageSupport {
    let defaults = UserDefaults.standard
}

class Preferences : LDataStorageSupport {
    //MARK: Auth
    var auth : Auth? {
        set (v) {
            if let a = v {
                do {
                    try self.defaults.set(JSONEncoder().encode(a), forKey: KKeyPreferences.auth)
                }catch{
                    print ("error = ", error.localizedDescription)
                }
            }else {
                self.defaults.removeObject(forKey: KKeyPreferences.auth)
            }
            _ = self.defaults.synchronize()
        }
        
        get {
            if let data = self.defaults.object(forKey: KKeyPreferences.auth) as? Data {
                do {
                    return try JSONDecoder().decode(Auth.self, from:data)
                }catch{
                    print ("error = ", error.localizedDescription)
                    return nil
                }
            }
            return nil
        }
    }
    
    var authToken : String {
        get {
            return "Bearer \(self.auth?.authToken ?? "")"
        }
    }
}

