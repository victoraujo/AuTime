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
    init() {
        userVM.fetchUser()
        activitiesVM.fetchData()
    }
    var body: some View {
        VStack{
            List(activitiesVM.activities){ activity in
                Text(activity.name)
            }
            if(userVM.users.count>0){
                Button(action: {
                    activitiesVM.createActivity(name: "Zaga", time: Date(), docId: userVM.users[0].id, handler: {})
                }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                })
            }
        }
    }

    

   
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
