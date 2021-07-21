//
//  AuTimeApp.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import SwiftUI
import Firebase

@main
struct AuTimeApp: App {

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil{
                SignUpView()
            }
        }
    }
}
