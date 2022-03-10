//
//  SubActivityViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 23/07/21.
//

import Firebase
import SwiftUI

class SubActivityViewModel: ObservableObject {
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    
    @Published var subActivities = [SubActivity]()
    @Published var activityReference: String?
    
    //static var shared = SubActivityViewModel()
    
    var db = Firestore.firestore()
    
    func createSubActivity(name: String, order: Int, image: UIImage, handler: @escaping () -> Void?) {
        guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name)") else {
            return
        }
        
        if let docId = userManager.session?.uid, let activityId = self.activityReference {
            
            do {
                try image.pngData()?.write(to: imageURL)
                self.imageManager.uploadImage(urlFile: imageURL, filePath: "users/\(docId)/SubActivities/\(name.unaccent())", completion: {
                    let _ = self.db.collection("users").document(docId).collection("activities").document(activityId).collection("subactivities").addDocument(data: [
                        "name": name,
                        "order": order
                    ]) { err in
                        if let err = err {
                            print("error adding document on CreateSubActivity:\(err)")
                        }
                        else{
                            handler()
                        }
                    }
                })
            }
            catch let error {
                print("Error \(error.localizedDescription) in Create SubActivity \(name)")
            }
        }
    }
    
    
    func fetchData() {
        if let docId = userManager.session?.uid, let activityId = self.activityReference {
            print("email: \(docId); id: \(activityId)")
            
            db.collection("users").document(docId).collection("activities").document(activityId).collection("subactivities").order(by: "order").addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returned")
                    return
                }
                
                self.subActivities = documents.map({docSnapshot -> SubActivity in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let subActivityComplete = data["complete"] as? Date ?? Date()
                    let subActivityName = data["name"] as? String ?? ""
                    let subActivityOrder = data["order"] as? Int ?? 0
                    
                    return SubActivity(id: docId, complete: subActivityComplete, name: subActivityName, order: subActivityOrder)
                })
                
            })
        }
        
    }
    
    
    func getImage(from subActivityName: String) -> UIImage {
        guard let email = self.userManager.session?.email else {
            print("Email was nil when call download image on SubActivityViewModel.")
            return UIImage()
        }
        let filePath = "users/\(String(describing: email))/SubActivities/\(subActivityName)"
        self.imageManager.downloadImage(from: filePath){}
        
        var photo: UIImage!
        if let data = self.imageManager.imageView.image?.pngData() {
            photo = UIImage(data: data)
        } else {
            photo = UIImage()
        }
        return photo
    }
    
}

