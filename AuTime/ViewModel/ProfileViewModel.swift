//
//  ProfileViewModel.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/11/21.
//

import SwiftUI
import Firebase
import CoreMIDI
import AVFoundation

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
    
    func updateProfilePhoto(photo: UIImage, endpoint: String, completion: @escaping () -> Void) {
                
        let dir = NSURL(fileURLWithPath: NSTemporaryDirectory())
        var url: URL!
        
        if let dirPath = dir.path {
            let filePath = "\(dirPath)/\(endpoint).png"
            print(filePath)
            
            if FileManager.default.fileExists(atPath: filePath) {
                url = URL(fileURLWithPath: filePath)
            } else {
                guard let imageURL = dir.appendingPathComponent("\(endpoint).png") else {
                    return
                }
                url = imageURL
            }
            
            do {
                if let email = userManager.session?.email {
                    try photo.pngData()?.write(to: url)
                    ImageViewModel().uploadImage(urlFile: url, filePath: "users/\(email)/Profile/\(endpoint)") {
                        if let url = URL(string: dirPath) {
                            do {
                            let _ = try FileManager.default.removeItem(at: url)
                            }
                            catch {}
                        }
                        completion()
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
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
    var parentName: String
    
    init() {
        self.childName = ""
        self.parentName = ""
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
