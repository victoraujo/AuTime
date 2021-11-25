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
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(self.activitiesManager.todayActivities, id: \.self) { activity in
                    VStack {
                        DailyActivityView(activity: activity)
                            .frame(width: geometry.size.width, height: geometry.size.width*0.425, alignment: .center)
                            .padding()
                    }
                    
                }
            }
        }
    }
}
