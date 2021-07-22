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
    @Published var users = [User]()
    @Published var session: UserSession? {didSet {self.didChange.send(self)}}
    
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser

    var didChange = PassthroughSubject<UserViewModel, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    public init() {}
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = UserSession(uid: user.uid, email: user.email)
            }
            else{
                self.session = nil
            }
        })
    }
        
    func fetchUser(){
        
        if let user = self.user {
            self.db.collection("users").whereField("user", isEqualTo: user.uid).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returned")
                    return
                }
                self.users = documents.map({docSnapshot -> User in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let userName = data["user"] as? String ?? ""
                    return User(id: docId, user: userName)
                })
            })
        }
        
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
            print("Logged out")
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
