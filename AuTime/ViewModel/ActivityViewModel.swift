//
//  ActivityViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 15/07/21.
//

import SwiftUI
import Firebase

class ActivityViewModel: ObservableObject {
    @Published var activities = [Activity]()
    @ObservedObject var userManager = UserViewModel()
    
    var db = Firestore.firestore()
    var user = Auth.auth().currentUser
    
    public init() {
        self.userManager.listen()
    }
    
    func createActivity(category: String, complete: Date, star: Bool, name: String, days: [Bool], time: Date, handler: @escaping () -> Void?) {
        
        if let docId = userManager.session?.email {
            let usersCollecttion = db.collection("users").document(docId).collection("activities").addDocument(data: [
                "category": category,
                "complete": complete,
                "generateStar": star,
                "name": name,
                "repeatDays": days,
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
    
    func fetchData() {
        if let docId = userManager.session?.email {
            print("Vou pegar a atividade do email \(docId)")
            
            db.collection("users").document(docId).collection("activities").addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No docs returend")
                    return
                }
                self.activities = documents.map({docSnapshot -> Activity in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let activityCategory = data["category"] as? String ?? ""
                    let activityComplete = data["complete"] as? Date ?? Date()
                    let activityStar = data["generateStar"] as? Bool ?? false
                    let activityName = data["name"] as? String ?? ""
                    let activityDays = data["repeatDays"] as? [Bool] ?? [false, false, false, false, false, false, false]
                    let activityTime = data["time"] as? Date ?? Date()
                    
                    return Activity(id: docId, category: activityCategory, complete: activityComplete, generateStar: activityStar, name: activityName, repeatDays: activityDays, time: activityTime)
                })
                
            })
        }
    }


}
