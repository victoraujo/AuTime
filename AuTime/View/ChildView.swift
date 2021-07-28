//
//  ChildView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct ChildView: View {
    
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @State var visualization: ViewMode = .day
    @State var currentActivity: Int = 1
    @Binding var showContentView: Bool
    var names: [String] = ["beber agua", "oi", "bom dia", "tomar banho"]
    var profile = UIImage(imageLiteralResourceName: "memoji.png")
    
    init(show: Binding<Bool>) {
        self._showContentView = show
        self.currentActivity = self.getCurrentActivityIndex()
    }
    
    func getHoursAndMinutes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
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
    
    enum ViewMode {
        case day, week
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center){
                HStack {
                    VStack(alignment: .leading) {
                        Text("Data de hoje")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.bottom)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.white)
                            
                            Text("Hora de hoje")
                                .foregroundColor(.white)
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                    }
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
                
                Text("O que vou fazer hoje?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black90Color)
                    .padding()
                
                VStack {
                    
                    Spacer()
                    
                    if self.names.count == 0 {
                        
                        Text("Nenhuma atividade cadastrada para hoje")
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundColor(.black90Color)
                            .frame(width: 0.9*geometry.size.width, alignment: .center)
                        
                        Spacer()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            ScrollViewReader { reader in
                                
                                HStack(alignment: .center, spacing: 0.1*geometry.size.width){
                                    
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
                        .frame(width: 0.9*geometry.size.width, alignment: .center)

                        
                        
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
                    }
                }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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
