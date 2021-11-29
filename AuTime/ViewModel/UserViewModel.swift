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
    @Published var profileInfo: Profile = Profile()
    @Published var logged = false
    
    var db = Firestore.firestore()
    
    var didChange = PassthroughSubject<UserViewModel, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
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
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.createUser()
            }
        })
    }
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else{
                self.logged = true
            }
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
    
    func createUser() {
        if let session = self.session {
            self.db.collection("users").document(session.email!).setData([
                "emails": [session.email!]
            ])
        }
    }
    
    func isLogged() -> Bool {
        return logged
    }
    
    func updateProfile(parentName: String? = nil, childName: String? = nil)  {
        var fields: [String:String] = [:]
        
        if let docId = self.session?.email {
            if let parentName = parentName {
                fields["parentName"] = parentName
            }
            
            if let childName = childName {
                fields["childName"] = childName
            }
            
            self.db.collection("users").document(docId).updateData(fields, completion: { _ in
                do {
                    self.profileInfo = try JSONDecoder().decode(Profile.self, from: JSONSerialization.data(withJSONObject: fields))
                } catch {
                    print("Erro ao atualizar info de perfil!")
                }
            })
        }
    }
    
}

struct Profile: Codable {
    var childName: String
    var parentName: String

    init() {
        self.childName = "João"
        self.parentName = "Rilda"
    }
    
    enum CodingKeys: String, CodingKey {
        case childName
        case parentName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.childName = try container.decode(String.self, forKey: .childName)
        self.parentName = try container.decode(String.self, forKey: .parentName)
    }
    
}
