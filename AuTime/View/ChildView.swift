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
    @State var visualization: ViewMode = .day
    @State var currentActivity: Int = 1
    @State var currentDate = ""
    @State var currentHour = ""
    @Binding var showContentView: Bool
    
    var names: [String] = ["beber agua", "oi", "bom dia", "tomar banho"]
    var profile = UIImage(imageLiteralResourceName: "memoji.png")
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    init(show: Binding<Bool>) {
        self._showContentView = show
        self.currentActivity = self.getCurrentActivityIndex()
    }
    
    func getCurrentActivityIndex() -> Int {
        let index = self.activitiesManager.todayActivities.firstIndex(where: {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let activityDate = dateFormatter.string(from: $0.complete)
            let todayDate  = dateFormatter.string(from: Date())
            
            print("\($0.name) Date: \(activityDate)")
            print("todayDate: \(todayDate)")
            
            return activityDate != todayDate
            
        })
        
        print("currentIndex = \(index ?? -1000)")
        return (index ?? self.activitiesManager.todayActivities.count) + 1
    }
    
    func getDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let days = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        
        return days[weekDay-1] + ", " + dateFormatter.string(from: date)
    }
    
    func getHoursAndMinutes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    enum ViewMode {
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
                        self.currentDate = self.getDate(from: Date())
                        self.currentHour = self.getHoursAndMinutes(from: Date())
                    })
                    .padding()
                    .frame(width: 0.27*geometry.size.width, height: 0.24*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Rectangle().fill(Color.greenColor).cornerRadius(21, [.bottomRight]))
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("Visualização")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black90Color)
                            .padding()
                        
                        HStack(alignment: .center) {
                            Button(action: {
                                self.visualization = .day
                            }, label: {
                                Text("Dia")
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
                        VStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .foregroundColor(.white)
                                    .cornerRadius(21)
                                    .offset(x: -2, y: 8)
                                
                                Image(uiImage: profile)
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
                            self.userManager.signOut()
                            self.activitiesManager.clearActivities()
                            self.showContentView.toggle()
                        }, label: {
                            VStack(alignment: .center){
                                
                                Image(systemName: "arrow.left.arrow.right.circle.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Text("Trocar Perfil")
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
                
                Text("O que vou fazer \(visualization == .day ? "hoje" : "esta semana")?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black90Color)
                    .padding()
                
                VStack {
                    
                    Spacer()
                    
                    if self.visualization == .day {
                        DailyActivitiesView(currentActivity: self.$currentActivity)
                        
                        Divider()
                            .frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.bottom)
                            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                        
                        PremiumActivityView()
                            .frame(width: 0.36*geometry.size.width ,height: 0.125*geometry.size.height, alignment: .center)
                            .onTapGesture {
                                //self.currentActivity = Int.random(in: 0..<self.activitiesManager.todayActivities.count)
                                print("Cliquei no paranaue")
                                print("index: \(self.currentActivity)")
                            }
                    } else {
                        WeekActivitiesView()
                            .frame(width: 0.9*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onAppear {
                self.activitiesManager.fetchData()
            }
            .onChange(of: self.userManager.session, perform: { _ in
                self.activitiesManager.fetchData()
            })
            .onChange(of: self.activitiesManager.todayActivities, perform: { _ in
                self.currentActivity = self.getCurrentActivityIndex()
            })
        }
    }
}

struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(show: .constant(true))
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
        
    }
}
