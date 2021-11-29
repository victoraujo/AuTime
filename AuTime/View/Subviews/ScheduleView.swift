//
//  ScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 02/08/21.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @ObservedObject var env: AppEnvironment
    @State var currentActivity: Int = 0
    @State var visualization: ScheduleViewMode = .today
    
    public enum ScheduleViewMode: Int {
        case today, week
    }
    
    init(_env: ObservedObject<AppEnvironment>) {
        self._env = _env
        currentActivity = self.activitiesManager.getCurrentActivityIndex(offset: 0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            // Today Schedule
            if visualization == .today {
                DailyScheduleView(env: env)
            }
            // Week Schedule
            else {
                WeekScheduleView(env: env)
            }
            
        }
        .navigationTitle("\(env.childName)'s Schedule")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button("Add Activity") {
                    print("Add activity on schedule!")
                }
            }
            
            ToolbarItem(placement: ToolbarItemPlacement.principal) {
                VStack {
                    Picker("Visualization", selection: $visualization) {
                        Text("Today").tag(ScheduleViewMode.today)
                        Text("Week").tag(ScheduleViewMode.week)
                    }
                    .pickerStyle(.segmented)
                }
                .frame(width: 0.3*UIScreen.main.bounds.width, alignment: .center)
            }
            
        }
    }
}

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            ScheduleView()
//                .previewInterfaceOrientation(.landscapeLeft)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
