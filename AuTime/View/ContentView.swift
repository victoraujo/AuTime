//
//  ContentView.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userManager: UserViewModel
    @ObservedObject var activitiesManager: ActivityViewModel
    @ObservedObject var subActivitiesManager: SubActivityViewModel
    
    @State var showSubActivitiesView = false
    @Binding var showContentView: Bool
    
    init(show: Binding<Bool>, userManager: UserViewModel) {
        self._showContentView = show
        self.userManager = userManager
        self.activitiesManager = ActivityViewModel(userManager: userManager)
        self.subActivitiesManager = SubActivityViewModel(userManager: userManager)
    }
    
    var body: some View {
        VStack{
            
            List(activitiesManager.activities){ activity in
                Text(activity.name)
                    .onTapGesture {
                        subActivitiesManager.activityReference = activity.id!
                        
                        print("ACTIVITY ID NA ACT: \(activity.id!)")
                        showSubActivitiesView.toggle()
                    }
            }
            
            
            
            Button(action: {
                activitiesManager.createActivity(category: "Teste", complete: Date(), star: true, name: "Zaga", days: [true, true, false, true, false, false, true], time: Date(), handler: {})
            }, label: {
                Text("ADD ACTIVITY")
            })
            .padding()
            
            
            Button(action: {
                showContentView = false
                userManager.signOut()
            }, label: {
                Text("DESLOGAR")
                    .foregroundColor(.red)
            })
            .padding()
        }
        
        .onAppear(perform: {
            self.activitiesManager.fetchData()
        })
        .fullScreenCover(isPresented: $showSubActivitiesView){ SubActivitiesView(userManager: self.userManager, subActivitiesManager: self.subActivitiesManager)
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show: .constant(true), userManager: UserViewModel())
    }
}
