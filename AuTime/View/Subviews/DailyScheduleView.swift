//
//  DailyScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 23/11/21.
//

import SwiftUI

struct DailyScheduleView: View {
    @ObservedObject var activitiesManager: ActivityViewModel = ActivityViewModel.shared
    @ObservedObject var env: AppEnvironment
    
    var body: some View {
        GeometryReader { geometry in
            let activities = self.activitiesManager.todayActivities
            
            if activities.count == 0 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack (alignment: .center){
                            Text("Nenhuma Atividade")
                                .font(.title2)
                                .bold()
                                .padding()
                            
                            Text("Você ainda não adicionou nenhuma atividade para o dia de hoje.")
                                .font(.subheadline)
                                .foregroundColor(.black90Color)
                        }
                        .frame(alignment: .center)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(height: geometry.size.height)
            } else {
                ScrollView(.vertical, showsIndicators: false) {                
                    ForEach(activities, id: \.self) { activity in
                        VStack {
                            DailyActivityView(activity: activity)
                                .frame(width: geometry.size.width, height: geometry.size.width*0.425, alignment: .center)
                                .padding()
                        }
                        .padding(.top)
                    }
                }
            }
        }
    }
}
