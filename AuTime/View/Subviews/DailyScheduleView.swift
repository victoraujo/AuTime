//
//  DailyScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 23/11/21.
//

import SwiftUI

struct DailyScheduleView: View {
    @ObservedObject var activitiesManager: ActivityViewModel = ActivityViewModel()
    @ObservedObject var env: AppEnvironment
    
    @State var todayActivities: [Activity] = []
    
    var body: some View {
        GeometryReader { geometry in
            if todayActivities.count == 0 {
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
                    ForEach(todayActivities, id: \.self) { activity in
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
        .onAppear(perform: {
            self.todayActivities = self.activitiesManager.todayActivities
        })
        .onChange(of: self.activitiesManager.todayActivities, perform: { activities in
            self.todayActivities = activities            
        })
    }
}
