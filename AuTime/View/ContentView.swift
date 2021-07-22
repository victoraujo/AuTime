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
        activitiesVM.fetchData()
    }
    
    var body: some View {
        VStack{
            List(activitiesVM.activities){ activity in
                Text(activity.name)
            }
            
            Button(action: {
                activitiesVM.createActivity(category: "Teste", complete: Date(), star: true, name: "Zaga", days: [true, true, false, true, false, false, true], time: Date(), handler: {})
            }, label: {
                Text("ADD ACTIVITY")
            })
            .padding()
            
            
            Button(action: {
                showContentView = false
                userVM.signOut()
            }, label: {
                Text("DESLOGAR")
                    .foregroundColor(.red)
            })
            .padding()
        }
        .onChange(of: userVM.session?.email, perform: { _ in
            self.activitiesVM.fetchData()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show: .constant(true))
    }
}
