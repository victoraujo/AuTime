//
//  ScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 02/08/21.
//

import SwiftUI

struct ScheduleView: View {
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    var colorTheme: Color = .blue
    
    func getHoursAndMinutes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack(alignment: .leading){
                                           
                Spacer()
                
                Text("Cronograma do dia")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black100Color)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .padding(.top)
                
                HStack {
                    
                    Divider()
                        .foregroundColor(.black100Color)
                        .font(.largeTitle)
                        .padding(.leading)
                
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .center, spacing: 0.1*UIScreen.main.bounds.height){
                            
                            ForEach(self.activitiesManager.todayActivities, id: \.self) {  activity in
                                HStack(alignment: .center) {
                                    
                                    Text("\(getHoursAndMinutes(from: activity.time))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black90Color)
                                        .padding(.vertical)
                                    
                                    Spacer()
                                    
                                    ActivityView(activity: activity, colorTheme: colorTheme)
                                        .frame(width: 314, height: 252, alignment: .center)
                                        .padding()
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading) {
                                        HStack (alignment: .center){
                                            Image(systemName: "clock")
                                                .resizable()
                                                .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(colorTheme)
                                                .padding()
                                            
                                            VStack (alignment: .leading){
                                                Text("Horário de conclusão")
                                                    .foregroundColor(colorTheme)
                                                    .font(.callout)
                                                    .fontWeight(.regular)
                                                
                                                Text("10:30")
                                                    .foregroundColor(colorTheme)
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        
                                        HStack (alignment: .center){
                                            Image(systemName: "face.smiling")
                                                .resizable()
                                                .frame(width: 35, height: 35, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(colorTheme)
                                                .padding()
                                            
                                            VStack (alignment: .leading){
                                                Text("Feedback de emoção")
                                                    .foregroundColor(colorTheme)
                                                    .font(.callout)
                                                    .fontWeight(.regular)
                                                
                                                Text("Feliz")
                                                    .foregroundColor(colorTheme)
                                                    .font(.title3)
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        
                                    }
                                    .padding()
                                    
                                    Spacer()
                                    
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.top)
                }
            }
            
            Spacer()
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
