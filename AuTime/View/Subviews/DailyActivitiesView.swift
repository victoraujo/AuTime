//
//  DailyActivitiesView.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/07/21.
//

import SwiftUI

struct DailyActivitiesView: View {
    @ObservedObject var activitiesManager = ActivityViewModel()
    @ObservedObject var premiumManager = PremiumViewModel.shared
    @ObservedObject var env: AppEnvironment
    @State var todayActivities: [Activity] = []
    @Binding var currentActivity: Int?
    @Binding var activityReference: Activity?
    
    init(currentActivity: Binding<Int?>, activityReference: Binding<Activity?>, env: ObservedObject<AppEnvironment>) {
        self._env = env
        self._currentActivity = currentActivity
        self._activityReference = activityReference
        self.todayActivities = self.activitiesManager.todayActivities
    }
    
    var body: some View {
        GeometryReader { geometry in
            if self.todayActivities.count == 0 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack (alignment: .center){
                            Text("Nenhuma Atividade")
                                .font(.title2)
                                .bold()
                                .padding()
                            
                            Text("O seu responsável ainda não adicionou nenhuma atividade para hoje.")
                                .font(.subheadline)
                                .foregroundColor(.black90Color)
                            
                        }
                        .frame(alignment: .center)
                        
                        Spacer()
                    }
                    .frame(idealWidth: geometry.size.width, minHeight: geometry.size.height*0.2)
                    Spacer()
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader { reader in
                        HStack(alignment: .center, spacing: 0.05*UIScreen.main.bounds.width){
                            
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                .foregroundColor(.clear)
                                .id(0)
                            
                            ForEach(Array(self.todayActivities.enumerated()), id: \.offset) { index, activity in
                                VStack {
                                    if (activity.category != "Prêmio" || premiumManager.premiumCount == 3 || DateHelper.datesMatch(activity.lastCompletionDate(), Date())){
                                        ActivityView(activity: activity, colorTheme: env.childColorTheme)
                                            .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                            .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
                                            .onTapGesture {
                                                if(!DateHelper.datesMatch(activity.lastCompletionDate(), Date())){
                                                    if activity.stepsCount > 0 {
                                                        activityReference = activity
                                                    }
                                                }
                                            }
                                        
                                        Text("\(DateHelper.getHoursAndMinutes(from: activity.time))")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black90Color)
                                            .padding(.top, UIScreen.main.bounds.height*0.09)
                                    }}
                                .id(index + 1)
                                
                            }
                            
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                .foregroundColor(.clear)
                                .id(self.todayActivities.count + 1)
                            
                        }
                        .onChange(of: self.currentActivity, perform: { index in
                            if let index = index {
                                withAnimation(.easeInOut(duration: Double(2*self.todayActivities.count))) {
                                    reader.scrollTo(index, anchor: .center)
                                    self.currentActivity = nil
                                }
                            }
                        })
                    }
                }
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
            }
        }
        .onAppear {
            self.todayActivities = self.activitiesManager.todayActivities
                                    
            let index = self.todayActivities.firstIndex(where: { !DateHelper.datesMatch(Date(), $0.lastCompletionDate()) }) ?? self.todayActivities.count - 1
            self.currentActivity = index + 1
        }
        .onChange(of: self.activitiesManager.todayActivities, perform: { _ in
            self.todayActivities = self.activitiesManager.todayActivities
            let index = self.todayActivities.firstIndex(where: { !DateHelper.datesMatch(Date(), $0.lastCompletionDate()) }) ?? self.todayActivities.count - 1
            self.currentActivity = index + 1
        })
    }
}
