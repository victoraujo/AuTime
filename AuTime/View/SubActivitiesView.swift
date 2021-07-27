//
//  SubActivitiesView.swift
//  AuTime
//
//  Created by Victor Vieira on 23/07/21.
//

import SwiftUI

struct SubActivitiesView: View {
    @ObservedObject var subActivitiesManager = SubActivityViewModel.shared
        
    var body: some View {
        VStack{
            List(subActivitiesManager.subActivities){ subActivity in
                Text(subActivity.name)
            }
            Button(action: {        
                subActivitiesManager.createSubActivity(complete: Date(), name: "Comer", handler: {})
                subActivitiesManager.fetchData()
            }, label: {
                Text("Add SubActivity")
            })
            
        }
        .onAppear(perform: {
            subActivitiesManager.fetchData()
        })
    }
}

struct SubActivitiesView_Previews: PreviewProvider {
    
    static var previews: some View {
        SubActivitiesView()
    }
}
