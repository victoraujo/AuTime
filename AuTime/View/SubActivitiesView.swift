//
//  SubActivitiesView.swift
//  AuTime
//
//  Created by Victor Vieira on 23/07/21.
//

import SwiftUI

struct SubActivitiesView: View {
    @ObservedObject var subActivitiesVM = SubActivityViewModel()
    @ObservedObject var userVM = UserViewModel()
    var activityId: String
    
    init(activityId: String){
        self.activityId = activityId
        subActivitiesVM.fetchData(activityId: activityId)
    }
    var body: some View {
        VStack{
            List(subActivitiesVM.subActivities){ subActivity in
                Text(subActivity.name)
            }
            Button(action: {
                subActivitiesVM.createSubActivity(activityId: activityId, complete: Date(), name: "Comer", handler: {})
            }, label: {
                Text("Add SubActivity")
            })
            
        }
//        .onChange(of: subActivitiesVM.userManager.session, perform: { value in
//            subActivitiesVM.fetchData(activityId: self.activityId)
//        })
        .onAppear(){
            subActivitiesVM.fetchData(activityId: self.activityId)
        }
    }
}

struct SubActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        SubActivitiesView(activityId: "")
    }
}
