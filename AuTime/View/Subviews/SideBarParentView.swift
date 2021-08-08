//
//  SideBarParentView.swift
//  AuTime
//
//  Created by Victor Vieira on 02/08/21.
//

import SwiftUI

struct SideBarParentView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @Binding var showContentView: Bool
    @Binding var visualization: ParentView.ParentViewMode
    
    var profile = UIImage(imageLiteralResourceName: "memoji.png")
    var menu = ["Criar atividade", "Mostrar cronograma", "Ver semanas", "Ver todas atividades", "Ver tutorias"]
    var colorTheme: Color = .blue
    
    var body: some View {
        GeometryReader{geometry in
            HStack{
                VStack(alignment: .center){
                    HStack(alignment: .center){
                        Button(action: {
                            self.userManager.signOut()
                            //                            self.activitiesManager.clearActivities()
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
                    }
                    .frame(width: geometry.size.width, height: 0.24*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Rectangle().fill(colorTheme).cornerRadius(21, [.bottomRight]))
                    
                    Text("Área do Responsável")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black100Color)
                        .padding()
                        .frame(alignment: .center)
                    
                    Spacer()
                    
                    ForEach(0..<menu.count){ index in
                        Button(action: {
                            visualization = ParentView.ParentViewMode(rawValue: index)!
                        }, label: {
                            Text(menu[index])
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 0.89*geometry.size.width, alignment: .center)
                                .background(Rectangle().fill(visualization.rawValue == index ? Color.blue90Color : colorTheme).cornerRadius(25))
                        })
                        
                        Spacer()
                    }
                    Spacer(minLength: 0.15*geometry.size.height)
                    
                }
                
            }
            .background(Color.black60Color)
            .edgesIgnoringSafeArea(.all)
            
        }
    }
}
struct SideBarParentView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarParentView(showContentView: .constant(true), visualization: .constant(ParentView.ParentViewMode(rawValue: 0)!))
    }
}