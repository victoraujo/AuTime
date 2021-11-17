//
//  ChildView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct ChildView: View {
    
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var env: AppEnvironment
    @ObservedObject var premiumManager = PremiumViewModel.shared
    
    @State var IconImage: Image = Image("")
    @State var visualization: ChildViewMode = .day
    @State var currentActivityReference: Activity? = nil
    @State var currentActivityIndex: Int? = 1
    @State var currentDate = DateHelper.getDateString(from: Date())
    @State var currentHour = DateHelper.getHoursAndMinutes(from: Date())
    @State var star: Int = 0
    
    // Change profile alert variables
    @State var isShowingChangeProfile: Bool = false
    @State var passwordWrited: String = ""
    @State var message: String = "Enter the password to access the parental control center."
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public enum ChildViewMode: Int {
        case day, week
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                HStack {
                    VStack(alignment: .leading) {
                        Text(self.currentDate)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.bottom)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.white)
                            
                            Text(self.currentHour)
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                    }
                    .onReceive(timer, perform: { _ in
                        self.currentDate = DateHelper.getDateString(from: Date())
                        self.currentHour = DateHelper.getHoursAndMinutes(from: Date())
                    })
                    .padding()
                    .frame(width: 0.27*geometry.size.width, height: 0.24*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Rectangle().fill(Color.greenColor).cornerRadius(21, [.bottomRight]))
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        
                        Text("Visualization")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black90Color)
                            .padding()
                        
                        HStack(alignment: .center) {
                            Button(action: {
                                self.visualization = .day
                            }, label: {
                                Text("Day")
                                    .foregroundColor(.black)
                            })
                                .frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(self.visualization == .day ? Color.greenColor : Color.clear)
                                .cornerRadius(7)
                            
                            Button(action: {
                                self.visualization = .week
                            }, label: {
                                Text("Week")
                                    .foregroundColor(.black)
                                
                            })
                                .frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(self.visualization == .week ? Color.greenColor : Color.clear)
                                .cornerRadius(7)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color.grayColor)
                        .cornerRadius(9)
                    }
                    .animation(.easeInOut)
                    
                    Spacer()
                    
                    HStack (alignment: .center){
                        VStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .foregroundColor(.white)
                                    .cornerRadius(21)
                                    .offset(x: -2, y: 8)
                                
                                Image(uiImage: env.childPhoto)
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .padding([.horizontal, .bottom])
                                    .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .background(Color.clear)
                                
                            }
                            
                            Text("João")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding([.horizontal, .bottom])
                        .padding(.horizontal)
                        
                        
                        Button(action: {
                            self.isShowingChangeProfile.toggle()
                        }, label: {
                            VStack(alignment: .center){
                                
                                Image(systemName: "arrow.left.arrow.right.circle.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Text("Change Profile")
                                    .foregroundColor(.white)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        })
                    }
                    .padding()
                    .frame(width: 0.27*geometry.size.width, height: 0.24*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Rectangle().fill(Color.greenColor).cornerRadius(21, [.bottomLeft]))
                }
                .padding(.bottom)
                
                Spacer()
                
                Text("What I will do \(visualization == .day ? "today" : "this week")?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black90Color)
                    .padding()
                
                VStack {
                    
                    Spacer()
                    
                    if self.visualization == .day {
                        DailyActivitiesView(currentActivity: self.$currentActivityIndex, activityReference: self.$currentActivityReference, env: _env)
                        
                        Divider()
                            .frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.bottom)
                            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                        
                        if let premium = activitiesManager.hasPremiumActivity() {
                            
                            PremiumActivityView(activity: premium, starCount: $premiumManager.premiumCount)
                                .frame(width: 0.36*geometry.size.width ,height: 0.125*geometry.size.height, alignment: .center)
                                .background(Rectangle().fill(Color.white).cornerRadius(21, [.topLeft, .topRight]).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
                                .offset(y: 6)
                                .onTapGesture {
                                    if let index = self.activitiesManager.todayActivities.firstIndex(where: {
                                        $0.category == "Prêmio"
                                        && (DateHelper.datesMatch(Date(), $0.lastCompletionDate()) || premiumManager.premiumCount == 3)
                                    }) {
                                        self.currentActivityIndex = index + 1
                                    }
                                }
                        }
                        
                    } else {
                        WeekActivitiesView()
                            .frame(width: 0.9*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                
            }
            .onAppear {
                self.activitiesManager.fetchData()
                self.env.showSubActivities = false
                self.currentActivityReference = nil
            }
            .onChange(of: self.userManager.session, perform: { _ in
                self.activitiesManager.fetchData()
            })
            .onChange(of: self.activitiesManager.todayActivities, perform: { _ in
                self.currentActivityIndex = self.activitiesManager.getCurrentActivityIndex(offset: 1)
            })
            .onChange(of: currentActivityReference, perform: { value in
                if value != nil {
                    self.env.showSubActivities = true
                } else {
                    self.env.showSubActivities = false
                }
                
            })
            .fullScreenCover(isPresented: $env.showSubActivities){
                SubActivitiesView(env: _env, activity: $currentActivityReference, star: $star)
            }
            .alert(isPresented: $isShowingChangeProfile,
                   TextAlert(title: "Change Profile",
                             message: message,
                             keyboardType: .default) { result in
                if let text = result {
                    if text == self.env.parentControlPassword {
                        env.changeProfile()
                        isShowingChangeProfile = false
                    } else {
                        message = "Wrong password! Enter the password to access the parental control center."
                        isShowingChangeProfile = true
                    }
                } else {
                    message = "Enter the password to access the parental control center."
                    isShowingChangeProfile = false
                }
            })
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            
        }
    }
}

//struct ChildView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChildView(env: AppEnvironment())
//            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
//            .environment(\.horizontalSizeClass, .compact)
//            .environment(\.verticalSizeClass, .compact)
//        
//    }
//}
