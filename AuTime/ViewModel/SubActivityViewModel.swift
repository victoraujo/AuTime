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
    @ObservedObject var userManager = UserViewModel()
    
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser
        
    func createSubActivity(activityId: String, complete: Date, name: String, handler: @escaping () -> Void?) {
        
        if let docId = userManager.session?.email {
            let usersCollecttion = db.collection("users").document(docId).collection("activities").document(activityId).collection("subactivities").addDocument(data: [
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
                //usersCollecttion.
            }
        }
    }
    
    func fetchData(activityId: String) {
        print(userManager.session?.email ?? "nada")
        if let docId = userManager.session?.email {
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
