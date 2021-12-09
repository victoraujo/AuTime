//
//  WeekScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 23/11/21.
//

import SwiftUI

struct WeekScheduleView: View {
    @ObservedObject var activitiesManager: ActivityViewModel = ActivityViewModel.shared
    @ObservedObject var env: AppEnvironment
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center){
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0..<7, id: \.self){ dayCount in
                        HStack{
                            Text(DateHelper.getDateString(from: DateHelper.addNumberOfDaysToDate(date: Date(), count: dayCount)))
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding([.top,.leading])
                                .foregroundColor(.black)
                            Spacer()
                        }
                        let weekActivities = self.activitiesManager.weekActivities[DateHelper.dayWeekIndex(offset: dayCount)]
                        
                        if weekActivities.count == 0 {
                            HStack {
                                Spacer()
                                VStack (alignment: .center){
                                    Text("Nenhuma Atividade")
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                    
                                    Text("Você ainda não adicionou nenhuma atividade a este dia.")
                                        .font(.subheadline)
                                        .foregroundColor(.black90Color)
                                    
                                }
                                .frame(alignment: .center)
                                
                                Spacer()
                            }
                            .frame(idealWidth: geometry.size.width, minHeight: geometry.size.height*0.2)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false){                            
                                HStack{
                                    ForEach(weekActivities){ activity in
                                        VStack(alignment: .leading){
                                            ActivityImageView(name: activity.name).frame(width: geometry.size.width*0.25, height: geometry.size.height*0.25, alignment: . center)
                                            Text(activity.category.uppercased())
                                                .font(.subheadline)
                                                .foregroundColor(.black90Color)
                                                .bold()
                                            
                                            HStack(alignment: .center){
                                                Text(activity.name)
                                                    .font(.title3)
                                                    .bold()
                                                Spacer()
                                                Text(DateHelper.getHoursAndMinutes(from: activity.time))
                                                    .font(.body)
                                                    .foregroundColor(.black90Color)
                                            }
                                            
                                            HStack(alignment: .center){
                                                Text("\(activity.stepsCount) passo\(activity.stepsCount > 1 ? "s" : "")")
                                                    .font(.body)
                                                    .foregroundColor(.black90Color)
                                                Spacer()
                                                Text(activity.lastCompletionFeedback())
                                                    .font(.body)
                                                    .foregroundColor(.black90Color)
                                                    .opacity(DateHelper.datesMatch(activity.lastCompletionDate(), DateHelper.addNumberOfDaysToDate(date: Date(), count: dayCount)) ? 1 : 0)
                                            }
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    Spacer()
                }
            }
        }
    }
}
