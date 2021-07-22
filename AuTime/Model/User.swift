//
//  User.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import Foundation

struct User: Encodable, Identifiable {
    var id: String
    var user: String
}

struct UserSession{
    var uid: String
    var email: String?
    
    init(uid: String, email: String?){
        self.uid = uid
        self.email = email
    }    
}
