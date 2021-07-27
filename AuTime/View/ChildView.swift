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
                            Image(systemName: "person.fill")
                                .resizable()
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .background(Color.white                       .cornerRadius(21))
                            
                            Text("João")
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding()
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
                                
                                if self.names.count == 1 {
                                    Rectangle()
                                        .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.clear)
                                }
                                
                                
                                ForEach(names, id: \.self) { name in
                                    VStack {
                                        ActivityView(activityName: name)
                                            .frame(width: 314, height: 252, alignment: .center)
                                            .padding(.bottom)
                                        
                                        Text("Horário")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black90Color)
                                            .padding(.top, 30)
                                    }
                                    
                                }
                                
                                if self.names.count > 2 {
                                    Rectangle()
                                        .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.clear)
                                }
                                
                            }
                        }
                        .frame(width: 0.9*geometry.size.width, alignment: .center)
                        .shadow(radius: 10)
                        
                        
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
