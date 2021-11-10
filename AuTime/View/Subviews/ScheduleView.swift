//
//  ScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 02/08/21.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @State var currentActivity: Int = 0
    @State var visualization: ScheduleViewMode = .today
    var colorTheme: Color = .blue
    
    public enum ScheduleViewMode: Int {
        case today, week
    }
    
    init() {
        currentActivity = self.activitiesManager.getCurrentActivityIndex(offset: 0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack(alignment: .center){
                Spacer()
                
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 0.1*UIScreen.main.bounds.height){
                        
                        ForEach(Array(self.activitiesManager.todayActivities.enumerated()), id: \.offset) {  index, activity in
                            HStack(alignment: .center) {
                                
                                Spacer()
                                
                                Text("\(DateHelper.getHoursAndMinutes(from: activity.time))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black90Color)
                                    .padding(.vertical)
                                
                                Spacer()
                                
                                ActivityView(activity: activity, colorTheme: colorTheme)
                                    .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                    .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
                                    .padding()
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    HStack (alignment: .center){
                                        Image(systemName: "clock")
                                            .resizable()
                                            .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? colorTheme : .clear)
                                            .padding()
                                        
                                        VStack (alignment: .leading){
                                            Text("Completion time")
                                                .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? colorTheme : .clear)
                                                .font(.callout)
                                                .fontWeight(.regular)
                                            
                                            Text(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? "\(DateHelper.getHoursAndMinutes(from: activity.lastCompletionDate()))" : "")
                                                .foregroundColor(colorTheme)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    
                                    HStack (alignment: .center){
                                        Image(systemName: "face.smiling")
                                            .resizable()
                                            .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? colorTheme : .clear)
                                            .padding()
                                        
                                        VStack (alignment: .leading){
                                            Text("Emotion feedback")
                                                .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? colorTheme : .clear)
                                                .font(.callout)
                                                .fontWeight(.regular)
                                            
                                            Text(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? activity.lastCompletionFeedback() : "")
                                                .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? colorTheme : .clear)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    
                                }
                                .padding()
                                
                                Spacer()
                                
                            }
                            .id(index)
                        }
                        
                        Rectangle()
                            .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.clear)
                    }
                    .padding()
                    
                }
            }
            .padding(.horizontal)
            
        }
        .navigationTitle("João's Schedule")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
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
