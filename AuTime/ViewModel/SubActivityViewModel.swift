//
//  SubActivityViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 23/07/21.
//

import Foundation
import Firebase
import SwiftUI

class SubActivityViewModel: ObservableObject {
    @Published var subActivities = [SubActivity]()
    @Published var activityReference: String?

    static var shared = SubActivityViewModel()
    
    var userManager = UserViewModel.shared
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser
        
    func createSubActivity(complete: Date, name: String, handler: @escaping () -> Void?) {
        
        if let docId = userManager.session?.email, let activityId = self.activityReference {
            let _ = db.collection("users").document(docId).collection("activities").document(activityId).collection("subactivities").addDocument(data: [
                "complete": complete,
                "name": name
            ])
            {err in
                if let err = err {
                    print("error adding document:\(err)")
                }
                else{
                    print("email: \(docId); id: \(activityId)")
                    handler()
                }
            }
        }
    }
    
    func fetchData() {
        print(userManager.session?.email ?? "Nenhum User")
        
        if let docId = userManager.session?.email, let activityId = self.activityReference {
            print("email: \(docId); id: \(activityId)")
            
            db.collection("users").document(docId).collection("activities").document(activityId).collection("subactivities").addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returend")
                    return
                }
                self.subActivities = documents.map({docSnapshot -> SubActivity in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let activityComplete = data["complete"] as? Date ?? Date()
                    let activityName = data["name"] as? String ?? ""
                    
                    return SubActivity(id: docId, complete: activityComplete, name: activityName)
                })
                
            })
        }
    }


}
