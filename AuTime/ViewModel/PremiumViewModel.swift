//
//  PremiumViewModel.swift
//  AuTime
//
//  Created by Victor Vieira on 09/11/21.
//

import Foundation
import Firebase
import SwiftUI

class PremiumViewModel: ObservableObject {
    public static var shared = PremiumViewModel()
    
    @ObservedObject var userManager = UserViewModel.shared
    @Published var premiumCount : Int = 0
    var db = Firestore.firestore()
    
    
    init(){
        fetchPremium()
    }
    
    func fetchPremium(){
        if let docId = userManager.session?.uid {
            db.collection("users").document(docId).collection("premium").document("premium").addSnapshotListener { snapshot, err in
                guard let document = snapshot else {
                    return
                }
                if let data  = document.data(){
                    self.premiumCount = data["count"] as? Int ?? 0}
                else {
                    self.premiumCount = 0
                }
            }
        }
    }
    
    private func setStarsTo(_ stars: Int){
        if let docId = userManager.session?.uid {
            db.collection("users").document(docId).collection("premium").document("premium").updateData(["count" : stars])
        }
    }
    
    func gainStar(){
        if(premiumCount < 3) {
            setStarsTo(premiumCount+1)
        }
    }
    
    func resetStars(){
        setStarsTo(0)
    }
}
