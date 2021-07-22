//
//  ContentView.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activitiesVM = ActivityViewModel()
    @ObservedObject var userVM = UserViewModel()
    @Binding var showContentView: Bool
    
    init(show: Binding<Bool>) {
        self._showContentView = show
        self.userVM.fetchUser()
        self.activitiesVM.fetchData()
    }
    
    var body: some View {
        VStack{
            List(activitiesVM.activities){ activity in
                Text(activity.name)
            }
            if(userVM.users.count > 0){
                Button(action: {
                    activitiesVM.createActivity(name: "Zaga", time: Date(), docId: userVM.users[0].id, handler: {})
                }, label: {
                    Text("ADD")
                })
            }
            
            Button(action: {
                showContentView = false
                userVM.signOut()
            }, label: {
                Text("DESLOGAR")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show: .constant(true))
    }
}
