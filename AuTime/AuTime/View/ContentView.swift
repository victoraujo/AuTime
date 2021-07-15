//
//  ContentView.swift
//  AuTime
//
//  Created by Victor Vieira on 07/07/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var cloudVM = ListBank()
    @ObservedObject var activitiesVM = ActivityViewModel()
    init() {
        activitiesVM.fetchData()
    }
    var body: some View {
        VStack{
            List(activitiesVM.activities){ activity in
                Text(activity.name)
            }
            Button(action: {
                activitiesVM.createActivity(name: "Zaga", time: Date(), handler: {})
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            
        }
    }

    

   
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
