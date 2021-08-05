//
//  SubActivitiesView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct SubActivitiesView: View {
    
    @ObservedObject var subActivitiesManager = SubActivityViewModel.shared
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var imageManager = ImageViewModel()
    @State var IconImage: Image = Image("")
    @State var currentDate = DateHelper.getDate(from: Date())
    @State var currentHour = DateHelper.getHoursAndMinutes(from: Date())
    
    @Binding var showContentView: Bool
    @Binding var showSubActivitiesView: Bool
    @Binding var currentActivityReference: Activity?
    
    let profile = UIImage(imageLiteralResourceName: "memoji.png")
    let colorTheme: Color = .greenColor
    let subActivitiesCount: Int = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(showContentView: Binding<Bool>, showSubActivitiesView: Binding<Bool>, activity: Binding<Activity?>) {
        self._showContentView = showContentView
        self._showSubActivitiesView = showSubActivitiesView
        self._currentActivityReference = activity
        
        if let activity = self.currentActivityReference {
            self.IconImage = Activity.getIconImage(from: activity.category)
        }
        
        self.subActivitiesManager.activityReference = currentActivityReference?.id
        
        let filePath = "users/\(String(describing: userManager.session?.email))/Activities/\(String(describing: currentActivityReference?.name))"
        self.imageManager.downloadImage(from: filePath)
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
                        self.currentDate = DateHelper.getDate(from: Date())
                        self.currentHour = DateHelper.getHoursAndMinutes(from: Date())
                    })
                    .padding()
                    .frame(width: 0.27*geometry.size.width, height: 0.24*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Rectangle().fill(Color.greenColor).cornerRadius(21, [.bottomRight]))
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        
                        Text("O que estou fazendo")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black90Color)
                            .padding()
                        
                        HStack(alignment: .center) {
                            Image(uiImage: self.imageManager.imageView.image ?? UIImage())
                            .resizable()
                            .frame(width: geometry.size.width*0.1, height: geometry.size.height*0.1, alignment: .center)
                            .padding(.trailing)
                            
                            IconImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, alignment: .center)
                                .foregroundColor(colorTheme)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading){
                                VStack(alignment: .leading){
                                    Text(self.currentActivityReference?.name ?? "SubAtividade sem nome")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(colorTheme)
                                    
                                    Text("\(subActivitiesCount > 0 ? String(subActivitiesCount) : "Nenhuma") subtarefa\(subActivitiesCount > 1 ? "s" : "")")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black90Color)
                                }
                            }
                            .padding(.trailing)
                            
                        }
                        .clipShape(RoundedRectangle.init(cornerRadius: 21))
                        .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 10, x: 0, y: 6))
                        
                        
                    }
                    .padding(.top)
                    
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
                
                Spacer()
                
                Text("")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black90Color)
                    .padding()
                    .padding(.top)
                
                VStack {
                    
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ScrollViewReader { reader in
                            HStack(alignment: .center, spacing: 0.05*UIScreen.main.bounds.width){
                                
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                    .foregroundColor(.clear)
                                    .id(0)
                                
                                ForEach(Array(self.subActivitiesManager.subActivities.enumerated()), id: \.offset) { index, subactivity in
                                    VStack {
                                        VStack (alignment: .center){
                                            Image(uiImage: UIImage(imageLiteralResourceName: "breakfast"))
                                                .resizable()
                                                .clipped()
                                                .scaledToFill()
                                                .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.21, alignment: .center)
                                                .cornerRadius(21, [.topRight, .topLeft])
                                            
                                            Text(subactivity.name)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding()
                                        }
                                        .background(colorTheme)
                                        .cornerRadius(21)
                                        .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                        .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
                                        
                                        .padding(.bottom)
                                        
                                        Text("Etapa \(index + 1)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black90Color)
                                            .padding(.top, 30)
                                    }
                                    .id(index + 1)
                                    
                                }
                                
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                    .foregroundColor(.clear)
                                    .id(self.subActivitiesManager.subActivities.count + 1)
                                
                            }
                            
                        }
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                        .padding()
                    }
                    
                    Divider()
                        .frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        
                        Button(action: {
                            self.showSubActivitiesView = false
                        }, label: {
                            Text("Voltar")
                                .foregroundColor(.black100Color)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .padding(.horizontal)
                                .frame(width: 0.25*geometry.size.width ,height: 0.07*geometry.size.height, alignment: .center)
                                .background(colorTheme)
                                .cornerRadius(28)
                                .padding(.trailing)
                            
                        })
                        
                        Button(action: {
                            print("Atividade concluída")
                            self.showSubActivitiesView = false
                        }, label: {
                            Text("Concluir Atividade")
                                .foregroundColor(.black100Color)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .padding(.horizontal)
                                .frame(width: 0.25*geometry.size.width ,height: 0.07*geometry.size.height, alignment: .center)
                                .background(colorTheme)
                                .cornerRadius(28)
                                .padding(.leading)
                        })
                        
                    }
                    .padding()
                    .padding(.bottom)
                    .frame(width: geometry.size.width ,height: 0.125*geometry.size.height, alignment: .center)
                    
                }
            }
            .onAppear {
                self.subActivitiesManager.activityReference = currentActivityReference?.id
                self.subActivitiesManager.fetchData()
                
                if let activity = self.currentActivityReference {
                    self.IconImage = Activity.getIconImage(from: activity.category)
                }
            }
            .onChange(of: self.userManager.session, perform: { _ in
                if let _ = self.userManager.session?.email {
                    self.subActivitiesManager.fetchData()
                }
            })
            .onDisappear {
                self.currentActivityReference = nil
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}

struct SubActivitiesView_Previews: PreviewProvider {
    
    static var previews: some View {
        SubActivitiesView(showContentView: .constant(true), showSubActivitiesView: .constant(true), activity: .constant(Activity(id: "sahjsa", category: "Saúde", complete: Date(), generateStar: true, name: "Caminhar", repeatDays: [], time: Date())))
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
        
    }
}
