//
//  user.swift
//  iAutolayout
//
//  Created by Niu Panfeng on 23/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import Foundation

struct User {
    
    let login: String
    let password: String
    let name: String
    let company: String
    let lastLoginTime: NSDate = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: +8 * 60 * 60)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return  formatter.dateFromString("2017-1-4 01:30:45")!
    }()
    
    static func login(login: String, password: String) -> User? {
        if let user = database[login] {
            if user.password == password{
                return user
            }
        }
        return nil
    }
    
    // DataBase
    static let database: Dictionary<String, User> = {
        var theDatabase = Dictionary<String, User>()
        for user in [
            User(login: "360", password: "foo", name: "Zhou Hongyi", company: "Qihoo 360 Co Ltd"),
            User(login: "beauty", password: "foo", name: "Beauty Lover", company: "Beauty International"),
            User(login: "pepsi", password: "foo", name: "Indra Nooyi", company: "Pepsi Company International"),
            User(login: "google", password: "foo", name: "Eric Emerson Schmidt", company: "Google Company International") ]
        {
           theDatabase[user.login] = user
        }
        return theDatabase
    }()
    
}

