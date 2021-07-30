//
//  DailyActivitiesView.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/07/21.
//

import SwiftUI

struct DailyActivitiesView: View {
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @Binding var currentActivity: Int
    
    func getHoursAndMinutes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { reader in
                
                HStack(alignment: .center, spacing: 0.1*UIScreen.main.bounds.width){
                    
                    Rectangle()
                        .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.clear)
                        .id(0)
                    
                    ForEach(Array(self.activitiesManager.todayActivities.enumerated()), id: \.offset) { index, activity in
                        VStack {
                            ActivityView(activity: activity)
                                .frame(width: 314, height: 252, alignment: .center)
                                .padding(.bottom)
                            
                            Text("\(getHoursAndMinutes(from: activity.time))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black90Color)
                                .padding(.top, 30)
                        }
                        .id(index + 1)
                        
                    }
                    
                    Rectangle()
                        .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.clear)
                        .id(self.activitiesManager.todayActivities.count + 1)
                    
                }
                .onAppear {
                    //print("Mudou o index para: \(self.currentActivity)")
                    reader.scrollTo(currentActivity)
                }
                .animation(.easeInOut)
            }
            
        }
        .frame(width: 0.9*UIScreen.main.bounds.width, alignment: .center)
    }
}
