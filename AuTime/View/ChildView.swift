//
//  ChildView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct ChildView: View {
    
    enum ViewMode {
        case day, week
    }
    
    @State var visualization: ViewMode = .day
    var names: [String] = ["beber agua", "oi", "bom dia", "tomar banho"]
    var profile = UIImage(imageLiteralResourceName: "memoji.png")
    
    func getHoursAndMinutes(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return timeString
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
                    
                    HStack (alignment: .top){
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
                        
                        Text("Nenhuma atividade cadastrada para hoje...")
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundColor(.black90Color)
                            .frame(width: 0.9*geometry.size.width, alignment: .center)
                        
                        Spacer()
                    } else {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(alignment: .center, spacing: 0.1*geometry.size.width){
                                
                                
                                Rectangle()
                                    .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.clear)
                                
                                
                                
                                ForEach(names, id: \.self) { name in
                                    VStack {
                                        ActivityView(activityName: name)
                                            .frame(width: 314, height: 252, alignment: .center)
                                            .padding(.bottom)
                                        
                                        Text("\(getHoursAndMinutes(from: Date()))")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black90Color)
                                            .padding(.top, 30)
                                    }
                                    
                                }
                                
                                Rectangle()
                                    .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.clear)
                                
                                
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
                    }
                }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
}

struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView()
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
        
    }
}
