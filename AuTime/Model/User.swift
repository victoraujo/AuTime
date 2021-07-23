//
//  User.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import Foundation

struct UserSession: Equatable {
    var uid: String
    var email: String?
    
    init(uid: String, email: String?){
        self.uid = uid
        self.email = email
    }    
}
