//
//  AuTimeApp.swift
//  AuTime
//
//  Created by Victor Vieira on 07/07/21.
//

import SwiftUI
import Firebase

@main
struct AuTimeApp: App {
    init(){
        FirebaseApp.configure()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously(completion: {_,_ in })
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }
    }
}
