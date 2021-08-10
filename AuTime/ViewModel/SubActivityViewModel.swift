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
        
    func createSubActivity(complete: Date, name: String, handler: @escaping () -> Void?) {
        print("Get subs")
        if let docId = userManager.session?.email, let activityId = self.activityReference {
            print("email: \(docId)    -       activity: \(activityId)")
            let _ = db.collection("users").document(docId).collection("activities").document(activityId).collection("subactivities").addDocument(data: [
                "complete": complete,
                "name": name
            ]) { err in
                if let err = err {
                    print("error adding document on CreateSubActivity:\(err)")
                }
                else{
                    print("email: \(docId); id: \(activityId)")
                    handler()
                }
            }
            
            guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ocapi") else {
                return
            }
            
            // Save image to URL
            do {
                try UIImage(named: "ocapi")!.pngData()?.write(to: imageURL)
                self.imageManager.uploadImage(urlFile: imageURL, filePath: "users/\(String(describing: userManager.session?.email))/SubActivities/\(name)")
            } catch {
                print("Can't upload the image \(name) to SubActivities folder.")
            }
        }
    }
    
    func fetchData() {
        print(userManager.session?.email ?? "Nenhum User")
        
        if let docId = userManager.session?.email, let activityId = self.activityReference {
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
        self.imageManager.downloadImage(from: filePath)
        
        var photo: UIImage!
        if let data = self.imageManager.imageView.image?.pngData() {
            photo = UIImage(data: data)
        } else {
            photo = UIImage()
        }
        return photo
    }
    
}
