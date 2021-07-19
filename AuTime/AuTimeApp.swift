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

    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser != nil{
                ContentView()
            }
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    if Auth.auth().currentUser == nil{
        Auth.auth().signInAnonymously(completion: {_,_ in
            @ObservedObject var userVM = UserViewModel()
            userVM.createUser()
        })
    }
    return true
  }
}
