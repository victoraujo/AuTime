//
//  SubActivitiesView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct SubActivitiesView: View {
    @ObservedObject var subActivitiesManager = SubActivityViewModel()
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @ObservedObject var premiumManager = PremiumViewModel.shared
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var profileManager = ProfileViewModel.shared
    @ObservedObject var childImageManager = ImageViewModel()
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var env: AppEnvironment
    
    @State var childPhoto: UIImage = UIImage()
    @State var subActivities: [SubActivity] = []
    @State var IconImage: Image = Image("")
    @State var currentDate = DateHelper.getDateString(from: Date())
    @State var currentHour = DateHelper.getHoursAndMinutes(from: Date())
    @State var activityImage: UIImage = UIImage()
    @State var subActivitiesCount: Int = 0
    @State var completes: [Bool] = []
    @State var showFeedbackPopUp: Bool = false
    @State var emotion: String = ""
    
    @Binding var currentActivityReference: Activity?
    @Binding var star: Int
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(env: ObservedObject<AppEnvironment>, activity: Binding<Activity?>, star: Binding<Int>) {
        self._env = env
        self._currentActivityReference = activity
        self._star = star
        
        if let activity = self.currentActivityReference {
            self.IconImage = Activity.getIconImage(from: activity.category)
        }
        
        self.subActivitiesManager.activityReference = currentActivityReference?.id
        
        if let email = userManager.session?.email , let name = currentActivityReference?.name {
            let filePath = "users/\(email)/Activities/\(name)"
            self.imageManager.downloadImage(from: filePath){}
        }
        
        self.subActivities = self.subActivitiesManager.subActivities
        
        self.subActivitiesCount = self.subActivities.count
        
        self.completes = []
        for _ in 0..<self.subActivitiesCount {
            self.completes.append(false)
        }
        
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
                            
                            Text("O que eu estou fazendo?")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black90Color)
                                .padding()
                            
                            HStack(alignment: .center) {
                                Image(uiImage: self.imageManager.imageView.image ?? UIImage())
                                    .resizable()
                                    .frame(width: geometry.size.width*0.1, height: geometry.size.height*0.1, alignment: .center)
                                
                                IconImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, alignment: .center)
                                    .foregroundColor(env.childColorTheme)
                                    .padding(.horizontal)
                                
                                VStack(alignment: .leading){
                                    VStack(alignment: .leading){
                                        Text(self.currentActivityReference?.name ?? "Subatividade sem nome")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(env.childColorTheme)
                                        
                                        Text("\(subActivitiesCount > 0 ? String(subActivitiesCount) : "Nenhuma") subatividade\(subActivitiesCount > 1 ? "s" : "")")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black90Color)
                                            .padding(.trailing)
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
                                    
                                    Text("Trocar Perfil")
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
                                    
                                    ForEach(Array(self.subActivities.enumerated()), id: \.offset) { index, subactivity in
                                        VStack {
                                            SubActivityView(colorTheme: env.childColorTheme, subActivityName: subactivity.name, completed: self.completes[index])
                                                .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
                                                .cornerRadius(21)
                                                .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
                                                .padding(.bottom)
                                                .onTapGesture {
                                                    self.completes[index].toggle()
                                                }
                                            
                                            Text("Passo \(index + 1)")
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
                                        .id(self.subActivitiesCount + 1)
                                    
                                }
                                .onChange(of: self.completes, perform: { _ in
                                    let index = self.completes.firstIndex(where: {$0 == false})
                                    withAnimation(.easeInOut(duration: Double(2*self.subActivitiesCount))) {
                                        reader.scrollTo((index ?? self.subActivitiesCount - 1) + 1, anchor: .center)
                                    }
                                    
                                })
                            }
                        }
                        
                        Divider()
                            .frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.bottom)
                            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        
                        Spacer()
                        
                        HStack(alignment: .center) {
                            
                            Button(action: {
                                self.env.isShowingSubActivities = false
                            }, label: {
                                Text("Voltar")
                                    .foregroundColor(.black100Color)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding()
                                    .padding(.horizontal)
                                    .frame(width: 0.25*geometry.size.width ,height: 0.07*geometry.size.height, alignment: .center)
                                    .background(env.childColorTheme)
                                    .cornerRadius(28)
                                    .padding(.trailing)
                                
                            })
                            
                            Button(action: {
                                if(currentActivityReference?.generateStar == true) {
                                    premiumManager.gainStar()
                                }
                                if(currentActivityReference?.category == "Prêmio"){
                                    premiumManager.resetStars()
                                }
                                self.showFeedbackPopUp = true
                            }, label: {
                                Text("Atividade Completada")
                                    .foregroundColor(.black100Color)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding()
                                    .padding(.horizontal)
                                    .frame(width: 0.25*geometry.size.width ,height: 0.07*geometry.size.height, alignment: .center)
                                    .background(env.childColorTheme)
                                    .cornerRadius(28)
                                    .padding(.leading)
                            })
                            
                        }
                        .padding()
                        .padding(.bottom)
                        .frame(width: geometry.size.width ,height: 0.125*geometry.size.height, alignment: .center)
                        
                    }
                }
                
                // Feedback Pop-Up
                VStack(alignment: .center) {
                    if let activity = currentActivityReference {
                        FeedbackChildView(env: env, showFeedbackPopUp: $showFeedbackPopUp, selectedEmotion: $emotion, star: $star, currentActivity: activity)
                            .frame(width: 0.6*geometry.size.width, height: 0.6*geometry.size.height, alignment: .center)
                            .opacity(showFeedbackPopUp ? 1 : 0)
                    }
                    
                    
                }
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .opacity((self.showFeedbackPopUp ? 1 : 0)))
                
                // Change Profile Pop-Up
                VStack(alignment: .center) {
                    ChangeProfileView(env: _env)
                        .frame(width: 0.5*geometry.size.width, height: 0.5*geometry.size.height, alignment: .center)
                        .opacity(env.isShowingChangeProfile ? 1 : 0)
                }
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .opacity((env.isShowingChangeProfile ? 1 : 0))                                )
                
            }
            .onAppear {
                self.subActivitiesManager.activityReference = currentActivityReference?.id
                self.subActivitiesManager.fetchData()
                
                if let activity = self.currentActivityReference {
                    self.IconImage = Activity.getIconImage(from: activity.category)
                }
                
                self.activityImage = self.imageManager.imageView.image ?? UIImage()
                self.subActivities = self.subActivitiesManager.subActivities
                
                self.subActivitiesCount = self.subActivities.count
                
                self.completes = []
                for _ in 0..<self.subActivitiesCount {
                    self.completes.append(false)
                }
                
                if let email = userManager.session?.email {
                    var childImageName: String = "\(profileManager.profileInfo.lastUpdateChildPhoto)"
                    childImageName += "-child.png"
                    let childPath = "users/\(email)/Profile/\(childImageName)"
                    self.childImageManager.downloadImage(from: childPath, {
                        self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                    })
                }
            }
            .onChange(of: self.subActivitiesManager.subActivities, perform: { _ in
                self.subActivities = self.subActivitiesManager.subActivities
                self.subActivitiesCount = self.subActivities.count
                
                self.completes = []
                for _ in 0..<self.subActivitiesCount {
                    self.completes.append(false)
                }
            })
            .onChange(of: profileManager.profileInfo, perform: { profile in
                if let email = userManager.session?.email {
                    var childImageName: String = "\(profileManager.profileInfo.lastUpdateChildPhoto)"
                    childImageName += "-child.png"
                    let childPath = "users/\(email)/Profile/\(childImageName)"
                    self.childImageManager.downloadImage(from: childPath) {
                        self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                    }
                }
            })
            .onChange(of: childImageManager.imageView.image, perform: { image in
                if let image = image {
                    self.childPhoto = image
                }
            })
            .onDisappear {
                self.currentActivityReference = nil
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}

struct SubActivityView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var imageManager = ImageViewModel()
    @State var image: UIImage = UIImage()
    
    var colorTheme: Color
    var subActivityName: String
    var completed: Bool
    
    init(colorTheme: Color, subActivityName: String, completed: Bool) {
        self.colorTheme = colorTheme
        self.subActivityName = subActivityName
        self.completed = completed
        
        if let email = userManager.session?.email {
            let filePath = "users/\(email)/SubActivities/\(subActivityName)"
            self.imageManager.downloadImage(from: filePath){}
        }
    }
    
    var body: some View {
        VStack (alignment: .center){
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .clipped()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.22, alignment: .center)
                    .cornerRadius(21, [.topRight, .topLeft])
                    .overlay(Color.black100Color.opacity( self.completed ? 0.825 : 0).cornerRadius(21, [.topRight, .topLeft]))
                
                
                VStack(alignment: .center) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 0.05*UIScreen.main.bounds.height, alignment: .center)
                        .foregroundColor(.white)
                    
                    Text("Passo Completado!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                }
                .opacity(self.completed ? 1 : 0)
                .animation(.easeInOut)
            }
            
            Text(subActivityName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(colorTheme)
                .padding()
                .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.08, alignment: .center)
            
        }
        .background(Color.white)
        .onAppear{
            if let email = userManager.session?.email {
                let filePath = "users/\(email)/SubActivities/\(subActivityName)"
                self.imageManager.downloadImage(from: filePath){
                    self.image = self.imageManager.imageView.image ?? UIImage()
                }
            }
        }
        .onChange(of: imageManager.imageView.image, perform: { value in
            if let email = userManager.session?.email {
                let filePath = "users/\(email)/SubActivities/\(subActivityName)"
                self.imageManager.downloadImage(from: filePath) {
                    self.image = self.imageManager.imageView.image ?? UIImage()
                }
            }
        })
    }
}


//struct SubActivitiesView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        SubActivitiesView(env: AppEnvironment(), activity: .constant(Activity(id: "sahjsa", category: "Saúde", complete: Date(), generateStar: true, name: "Caminhar", repeatDays: [], time: Date(), stepsCount: 0)))
//            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
//            .environment(\.horizontalSizeClass, .compact)
//            .environment(\.verticalSizeClass, .compact)
//        
//    }
//}
