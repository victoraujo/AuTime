//
//  ActivityViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 15/07/21.
//

import Foundation
import Firebase
class ActivityViewModel: ObservableObject {
    @Published var activities = [Activity]()
    private var db = Firestore.firestore()
    private var user = Auth.auth().currentUser
    
    func createActivity(name: String, time: Date, docId: String, handler: @escaping () -> Void?){
        if(user != nil){
            let usersCollecttion = db.collection("users").document(docId).collection("activities").addDocument(data: [
                "name": name,
                "time": time
            ])
            {err in
                if let err = err {
                    print("error adding document:\(err)")
                }
                else{
                    handler()
                }
                //usersCollecttion.
            }
        }
    }
    
    func fetchData(){
        if(user != nil){
            db.collection("activity").addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returnd")
                    return
                }
                self.activities = documents.map({docSnapshot -> Activity in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let activityName = data["name"] as? String ?? ""
                    let activityTime = data["time"] as? Date ?? Date()
                    return Activity(id: docId, name: activityName, time: activityTime)
                })
                
            })
        }
    }


}
