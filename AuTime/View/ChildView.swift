//
//  ChildView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct ChildView: View {
    
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @ObservedObject var profileManager = ProfileViewModel.shared
    @ObservedObject var premiumManager = PremiumViewModel.shared
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var childImageManager = ImageViewModel()
    @ObservedObject var env: AppEnvironment
    
    @State var childPhoto: UIImage = UIImage()
    @State var IconImage: Image = Image("")
    @State var visualization: ChildViewMode = .day
    @State var currentActivityReference: Activity? = nil
    @State var currentActivityIndex: Int? = 1
    @State var currentDate = DateHelper.getDateString(from: Date())
    @State var currentHour = DateHelper.getHoursAndMinutes(from: Date())
    @State var star: Int = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public enum ChildViewMode: Int {
        case day, week
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                                    Text("Hoje")
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
                                    Text("Semana")
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
                            Spacer()
                            
                            VStack {
                                Image(uiImage: childPhoto)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width*0.075, height: UIScreen.main.bounds.width*0.075, alignment: .center)
                                    .clipShape(Circle())
                                
                                Text("\(profileManager.getChildName())")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .padding([.horizontal, .bottom])                            
                            
                            Spacer()
                            
                            Button(action: {
                                env.isShowingChangeProfile = true
                            }, label: {
                                VStack(alignment: .center){
                                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    
                                    Text("Alterar Perfil")
                                        .foregroundColor(.white)
                                        .font(.system(size: geometry.size.width*0.0125, weight: .bold))
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                            })
                            
                            Spacer()
                        }
                        .padding()
                        .padding(.top)
                        .frame(width: 0.27*geometry.size.width, height: 0.24*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Rectangle().fill(Color.greenColor).cornerRadius(21, [.bottomLeft]))
                    }
                    
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
                
                // Change Profile Pop-Up
                VStack(alignment: .center) {
                    ChangeProfileView(env: _env)
                        .frame(width: 0.5*geometry.size.width, height: 0.5*geometry.size.height, alignment: .center)
                        .opacity(env.isShowingChangeProfile ? 1 : 0)
                }
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .opacity((env.isShowingChangeProfile ? 1 : 0)))
                
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onAppear {
                self.activitiesManager.fetchData()
                self.env.isShowingSubActivities = false
                self.currentActivityReference = nil
                
                if let email = userManager.session?.email {
                    let childPath = "users/\(email)/Profile/child"
                    self.childImageManager.downloadImage(from: childPath) {
                        self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                    }
                }
            }
            .onChange(of: self.userManager.session, perform: { _ in
                self.activitiesManager.fetchData()
            })
            .onChange(of: self.activitiesManager.todayActivities, perform: { _ in
                self.currentActivityIndex = self.activitiesManager.getCurrentActivityIndex(offset: 1)
            })
            .onChange(of: currentActivityReference, perform: { value in
                if value != nil {
                    self.env.isShowingSubActivities = true
                } else {
                    self.env.isShowingSubActivities = false
                }
                
            })
            .onChange(of: profileManager.profileInfo, perform: { profile in
                if let email = userManager.session?.email {
                    let childPath = "users/\(email)/Profile/child"
                    self.childImageManager.downloadImage(from: childPath) {
                        self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                    }
                }
            })
            .onChange(of: childImageManager.imageView.image, perform: { _ in
                if let email = userManager.session?.email {
                    let filePath = "users/\(email)/Profile/child"
                    self.childImageManager.downloadImage(from: filePath) {
                        self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                    }
                }
            })
            .fullScreenCover(isPresented: $env.isShowingSubActivities){
                SubActivitiesView(env: _env, activity: $currentActivityReference, star: $star)
            }
            
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
