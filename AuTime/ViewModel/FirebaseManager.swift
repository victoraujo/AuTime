//
//  FirebaseManager.swift
//  AuTime
//
//  Created by Matheus Andrade on 21/07/21.
//

import Foundation
import Firebase
import Combine

class FirebaseManager: ObservableObject {
    
    static var db = Firestore.firestore()
    static var user = Auth.auth().currentUser
    var didChange = PassthroughSubject<FirebaseManager, Never>()
    @Published var session: UserSession? {didSet {self.didChange.send(self)}}
    var handle: AuthStateDidChangeListenerHandle?
    
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
    
    public init() {}
    
    class func fetchUser() -> [User] {
        var users: [User] = []
        
        if let user = user {
            db.collection("users").whereField("user", isEqualTo: user.uid).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returned")
                    return
                }
                users = documents.map({docSnapshot -> User in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let userName = data["user"] as? String ?? ""
                    return User(id: docId, user: userName)
                })
            })
        }
        
        return users
    }
    
    class func signUp(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else{
                print("Signed Up!")}
        })
    }
    
    class func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else{
                print("Signed In!")}
        })
    }
    
    class func signOut() {
        do {
            try Auth.auth().signOut()
            print("Logged out")
        } catch let error {
            print("Logout error: \(error.localizedDescription)")
        }
    }
    
    class func isLogged() -> Bool {
        return (Auth.auth().currentUser?.isEmailVerified ?? false)
    }
    
}
struct UserSession{
    var uid: String
    var email: String?
    
    init(uid: String, email: String?){
        self.uid = uid
        self.email = email
    }
    
}
