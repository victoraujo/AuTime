//
//  UserViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users = [User]()
    
    func fetchUser() {
        self.users = FirebaseManager.fetchUser()
    }
    
    func signUp(email: String, password: String) {
        FirebaseManager.signUp(email: email, password: password)
    }

    func signIn(email: String, password: String) {
        FirebaseManager.signIn(email: email, password: password)
    }
    
    func signOut() {
        FirebaseManager.signOut()
    }
    
}
