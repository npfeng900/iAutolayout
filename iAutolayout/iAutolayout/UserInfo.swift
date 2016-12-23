//
//  user.swift
//  iAutolayout
//
//  Created by Niu Panfeng on 23/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import Foundation

struct User {
    
    let name: String
    let company: String
    let login: String
    let password: String
    
    static func login(login: String, password: String) -> User? {
        if let user = database[login] {
            if user.password == password{
                return user
            }
        }
        return nil
    }
    
    static let database: Dictionary<String, User> = {
        var theDatabase = Dictionary<String, User>()
        for user in [
            User(name: "Zhou Hongyi", company: "Qihoo 360 Co Ltd", login: "360", password: "foo"),
            User(name: "Pan Jinlian", company: "Jinlian International", login: "lichunyuan", password: "foo"),
            User(name: "Indra Nooyi", company: "Pepsi Company International", login: "pepsi", password: "foo"),
            User(name: "Eric Emerson Schmidt", company: "Google Company International ", login: "google", password: "foo")
            ]
        {
           theDatabase[user.login] = user
        }
        return theDatabase
    }()
    
}