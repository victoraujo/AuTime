//
//  UserViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth

class UserViewModel: ObservableObject {
    public static var shared = UserViewModel()
    
    @Published var session: UserSession? {didSet {self.didChange.send(self)}}
    @Published var logged = false
    var error: Error?
    
    var db = Firestore.firestore()
    
    var didChange = PassthroughSubject<UserViewModel, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    enum erro {
        case none
        case invalid
    }
    
    
    public init() {
        self.listen()
    }
    
    func listen(){
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
    
    func signUp(email: String, password: String, parentName: String, childName: String, completion: (_ erro: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                self.error = error
                print(error.localizedDescription)
            } else {
                print("Signed Up!")
                self.createUser(parentName: parentName, childName: childName)
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = parentName
                changeRequest?.commitChanges { (error) in
                    print(error?.localizedDescription ?? "none")
                }
                self.confirmEmail()
            }
        })
        completion(error)
    }
    
    func signIn(email: String, password: String, completion: @escaping () -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else{                
                self.logged = true
            }
            completion()
        })
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.logged = false
        } catch let error {
            print("Logout error: \(error.localizedDescription)")
        }
    }
    
    func createUser(parentName: String, childName: String) {
        if let session = self.session {
            self.db.collection("users").document(session.email!).setData([
                "emails": [session.email!],
                "parentName": parentName,
                "childName": childName,
                "lastUpdateChildPhoto": 0,
                "lastUpdateParentPhoto": 0
            ])
        }
    }
    
    func isVerified() -> Bool {
        return (Auth.auth().currentUser?.isEmailVerified ?? false)
    }
    
    func confirmEmail(){
        Auth.auth().currentUser?.sendEmailVerification(completion: { err in
            guard let error = err else{ return }
            print(error.localizedDescription)
        })
    }
    
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
          // ...
        }
    }
    
    func changePassword(to password: String) {
        
    }
}
