//
//  ProfileViewModel.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/11/21.
//

import SwiftUI
import Firebase

class ProfileViewModel: ObservableObject {
    public static var shared = ProfileViewModel()
    
    @ObservedObject var userManager = UserViewModel.shared
    @Published var profileInfo: Profile
    
    var db = Firestore.firestore()
    
    init() {
        self.profileInfo = Profile()
        self.listen()
    }
    
    func listen() {
        if let docId = userManager.session?.email {
            db.collection("users").document(docId).collection("profile").document("profile").addSnapshotListener { snapshot, err in
                guard let document = snapshot else {
                    return
                }
                
                if let data = document.data() {
                    self.profileInfo.parentName = data["parentName"] as? String ?? ""
                    self.profileInfo.childName = data["childName"] as? String ?? ""
                    self.profileInfo.parentPhoto = self.getImage(from: "parent")
                    self.profileInfo.childPhoto = self.getImage(from: "child")
                }                                
            }
        }

    }
    
    func updateProfile(parentName: String? = nil, childName: String? = nil)  {
        var fields: [String:String] = [:]
        
        if let docId = userManager.session?.email {
            if let parentName = parentName {
                fields["parentName"] = parentName
            }
            
            if let childName = childName {
                fields["childName"] = childName
            }
            
            self.db.collection("users").document(docId).collection("profile").document("profile").updateData(fields, completion: { _ in
                do {
                    self.profileInfo = try JSONDecoder().decode(Profile.self, from: JSONSerialization.data(withJSONObject: fields))
                } catch {
                    print("Erro ao atualizar info de perfil!")
                }
            })
        }
    }
    
    func getImage(from photoName: String) -> UIImage {
        guard let email = self.userManager.session?.email else {
            print("Email was nil when call download image on SubActivityViewModel.")
            return UIImage()
        }
        
        let filePath = "users/\(String(describing: email))/Profile/\(photoName)"
        let imageManager = ImageViewModel()
        imageManager.downloadImage(from: filePath) {}
        
        var photo: UIImage!
        if let data = imageManager.imageView.image?.pngData() {
            photo = UIImage(data: data)
        } else {
            photo = UIImage()
        }
        return photo
    }
    
    func getParentName() -> String {
        return self.profileInfo.parentName
    }
    
    func getChildName() -> String {
        return self.profileInfo.childName
    }
    
    func getParentPhoto() -> UIImage {
        return self.profileInfo.parentPhoto
    }
    
    func getChildPhoto() -> UIImage {
        return self.profileInfo.childPhoto
    }
}

struct Profile: Codable, Equatable {
    var childName: String
    var childPhoto: UIImage
    
    var parentName: String
    var parentPhoto: UIImage

    init() {
        self.childName = ""
        self.parentName = ""
        self.childPhoto = UIImage()
        self.parentPhoto = UIImage()
    }
    
    enum CodingKeys: String, CodingKey {
        case childName
        case parentName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.childName = try container.decode(String.self, forKey: .childName)
        self.parentName = try container.decode(String.self, forKey: .parentName)
        
        self.childPhoto = UIImage()
        self.parentPhoto = UIImage()
    }
    
}
