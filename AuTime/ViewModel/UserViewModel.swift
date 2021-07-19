//
//  UserViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import Foundation
import Firebase
class UserViewModel: ObservableObject {
    @Published var users = [User]()
    private var db = Firestore.firestore()
    private var user = Auth.auth().currentUser
    
    func createUser(){
        if(user != nil){
            db.collection("users").addDocument(data: [
                "user": user?.uid
            ])
        }
    }
    func fetchUser(){
        if(user != nil){
            db.collection("users").whereField("user", isEqualTo: user?.uid).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returnd")
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
    
}
