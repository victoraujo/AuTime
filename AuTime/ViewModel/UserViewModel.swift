//
//  UserViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import Foundation
import Firebase
import Combine

class UserViewModel: ObservableObject {
    public static var shared = UserViewModel()
    
    @Published var session: UserSession? {didSet {self.didChange.send(self)}}
    
    var db = Firestore.firestore()

    var didChange = PassthroughSubject<UserViewModel, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    public init() {
        self.listen()
    }
    
    func listen(){
        print("Listening User")
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = UserSession(uid: user.uid, email: user.email)
            }
            else{
                self.session = nil
            }
        })
        
        self.objectWillChange.send()
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Signed Up!")
                self.createUser()
            }
        })
    }
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else{
                print("Signed In!")
            }
        })
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Logged out!")
        } catch let error {
            print("Logout error: \(error.localizedDescription)")
        }
    }
    
    func createUser() {
        
        if let session = self.session {
            self.db.collection("users").document(session.email!).setData([
                "emails": [session.email!]
            ])
        }
    }
    
    func isLogged() -> Bool {
        return (Auth.auth().currentUser?.isEmailVerified ?? false)
    }
    
}
