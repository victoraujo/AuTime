//
//  ProfileViewModel.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/11/21.
//

import SwiftUI
import Firebase
import Combine
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    public static var shared = ProfileViewModel()
    
    @ObservedObject var userManager = UserViewModel.shared
    @Published var profileInfo: Profile
    var session: UserSession? {didSet {self.didChange.send(self)}}
    
    var db = Firestore.firestore()
    
    var didChange = PassthroughSubject<ProfileViewModel, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.profileInfo = Profile()
        self.listenUser()
    }
    
    func listenUser() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = UserSession(uid: user.uid, email: user.email)
                self.listen()
            }
            else{
                self.session = nil
            }
        })
    }
    
    func listen() {
        if let docId = self.session?.email {
            db.collection("users").document(docId).addSnapshotListener { snapshot, err in
                guard let document = snapshot else {
                    return
                }
                
                if let data = document.data() {
                    self.profileInfo.parentName = data["parentName"] as? String ?? ""
                    self.profileInfo.childName = data["childName"] as? String ?? ""
                    self.profileInfo.lastUpdateChildPhoto = data["lastUpdateChildPhoto"] as? Int ?? 0
                    self.profileInfo.lastUpdateParentPhoto = data["lastUpdateParentPhoto"] as? Int ?? 0
                }
            }
        }
        
    }
    
    func updateProfile(parentName: String? = nil, childName: String? = nil, lastUpdateParentPhoto: Int? = nil, lastUpdateChildPhoto: Int? = nil)  {
        var fields: [String:Any] = [:]
        fields["parentName"] = self.getParentName()
        fields["childName"] = self.getChildName()
        fields["lastUpdateParentPhoto"] = self.profileInfo.lastUpdateParentPhoto
        fields["lastUpdateChildPhoto"] = self.profileInfo.lastUpdateChildPhoto
                
        if let docId = userManager.session?.uid {
            if let parentName = parentName {
                fields["parentName"] = parentName
            }
            
            if let childName = childName {
                fields["childName"] = childName
            }
            
            if let lastUpdateParentPhoto = lastUpdateParentPhoto {
                fields["lastUpdateParentPhoto"] = lastUpdateParentPhoto
            }
            
            if let lastUpdateChildPhoto = lastUpdateChildPhoto {
                fields["lastUpdateChildPhoto"] = lastUpdateChildPhoto
            }                                                
            
            self.db.collection("users").document(docId).updateData(fields, completion: { _ in
                do {
                    self.profileInfo = try JSONDecoder().decode(Profile.self, from: JSONSerialization.data(withJSONObject: fields))
                } catch let error {
                    print(error.localizedDescription)
                    print("Erro ao atualizar info de perfil!")
                }
            })
        }
    }
    
    func updateProfilePhoto(photo: UIImage, endpoint: String, completion: @escaping () -> Void) {
        
        let dir = NSURL(fileURLWithPath: NSTemporaryDirectory())
        
        guard let imageURL = dir.appendingPathComponent("\(endpoint)") else {
            return
        }
        
        do {
            if let email = userManager.session?.email {
                try photo.pngData()?.write(to: imageURL)
                let number = endpoint == "child" ? (self.profileInfo.lastUpdateChildPhoto + 1) : (self.profileInfo.lastUpdateParentPhoto + 1)
                let imageName = "\(number)" + "-" + endpoint + ".png"
                ImageViewModel().uploadImage(urlFile: imageURL, filePath: "users/\(email)/Profile/\(imageName)") {
                    if endpoint == "child" {
                        self.updateProfile(lastUpdateChildPhoto: number)
                    } else {
                        self.updateProfile(lastUpdateParentPhoto: number)
                    }
                    completion()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getParentName() -> String {
        return self.profileInfo.parentName
    }
    
    func getChildName() -> String {
        return self.profileInfo.childName
    }
}

struct Profile: Codable, Equatable {
    var childName: String
    var lastUpdateChildPhoto: Int
    var parentName: String
    var lastUpdateParentPhoto: Int
    
    init() {
        self.childName = ""
        self.parentName = ""
        self.lastUpdateParentPhoto = 0
        self.lastUpdateChildPhoto = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case childName
        case parentName
        case lastUpdateParentPhoto
        case lastUpdateChildPhoto
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.childName = try container.decode(String.self, forKey: .childName)
        self.parentName = try container.decode(String.self, forKey: .parentName)
        self.lastUpdateParentPhoto = try container.decode(Int.self, forKey: .lastUpdateParentPhoto)
        self.lastUpdateChildPhoto = try container.decode(Int.self, forKey: .lastUpdateChildPhoto)
    }
    
}
