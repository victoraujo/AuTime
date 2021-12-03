//
//  FeedbackChildView.swift
//  AuTime
//
//  Created by Matheus Andrade on 09/08/21.
//

import SwiftUI

struct FeedbackChildView: View {

    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @ObservedObject var env: AppEnvironment
    @State var showEmotions: Bool = true
    
    @Binding var showFeedbackPopUp: Bool
    @Binding var selectedEmotion: String
    @Binding var star: Int
    var currentActivity: Activity
    
    let emotions: [String] = ["Irritado", "Triste", "Feliz"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack (alignment: .center) {
                    
                    Spacer()
                    
                    if showEmotions {
                    
                        Text("\(env.childName), como você está se sentindo?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black100Color)
                            .multilineTextAlignment(.leading)
                            .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding()
                        
                        HStack(alignment: .top){
                            ForEach(emotions, id: \.self) { emotion in
                                VStack(alignment: .center) {
                                    Activity.getFeedbackEmoji(from: emotion)
                                        .font(.system(size: 0.1*geometry.size.width))
                                        .padding()
                                        .background( emotion == selectedEmotion ? env.childColorTheme : Color.clear)
                                        .cornerRadius(21)

                                      
                                    Text("\(emotion)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black100Color)
                                    
                                }
                                .onTapGesture {
                                    if selectedEmotion == emotion {
                                        self.selectedEmotion = ""
                                    } else {
                                        self.selectedEmotion = emotion
                                    }
                                    
                                }
                                .padding()
                            }
                        }
                        .padding()
                    } else if currentActivity.generateStar {
                        Text("Parabéns!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.pinkColor)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        Text("você ganhou uma estrela por ter sido tão dedicado!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black100Color)
                            .multilineTextAlignment(.leading)
                            .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding([.horizontal, .bottom])
                        
                        // TO DO: CHANGE IMAGE FOR WON STAR!!
                        // current image is a João's memoji
                        Image("WonStar")
                            .resizable()
                            .frame(width: 0.3*geometry.size.width, height: 0.3*geometry.size.height, alignment: .center)
                            .padding()
                    } else {
                        Text("Parabéns!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.pinkColor)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                        Text("você completou uma atividade")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black100Color)
                            .multilineTextAlignment(.leading)
                            .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding([.horizontal, .bottom])
                        
                        // TO DO: CHANGE IMAGE FOR CONGRATULATIONS!!
                        // current image is a João's memoji
                        Image("Congratulations")
                            .resizable()
                            .frame(width: 0.3*geometry.size.width, height: 0.3*geometry.size.height, alignment: .center)
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center){
                        
                        Button(action: {
                            // First pop-up is presented  -> Show Second pop-up
                            if showEmotions {
                                if selectedEmotion != "" {
                                    self.showEmotions = false
                                }
                            }
                            // Second pop-up is presented -> Dismiss pop-up view
                            else {
                                self.activitiesManager.completeActivity(activity: currentActivity, time: Date(), feedback: selectedEmotion)
                                
                                self.showFeedbackPopUp = false
                                self.showEmotions = true
                                self.env.isShowingSubActivities = false
                                self.selectedEmotion = ""
                            }
                            
                        }, label: {
                            Text("Confirmar")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 0.4*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .background(env.childColorTheme)
                                .cornerRadius(21)
                        })
                        
                        .padding()
                                                
                        Button(action: {
                            // First pop-up is presented  -> Show Second pop-up
                            if showEmotions {
                                self.showEmotions = false
                            }
                            // Second pop-up is presented -> Dismiss pop-up view
                            else {
                                self.activitiesManager.completeActivity(activity: currentActivity, time: Date(), feedback: "No Feedback")
                                                                    
                                self.selectedEmotion = ""
                                self.showFeedbackPopUp = false
                                self.showEmotions = true
                                self.env.isShowingSubActivities = false
                            }
                        }, label: {
                            Text(showEmotions ? "Pular" : "Sair")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(env.childColorTheme)
                            
                        })
                        .padding()
                    }
                    
                    Spacer()
                    
                }
                .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
            }
            
        }
        
    }
}

//struct FeedbackChildView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedbackChildView(env: AppEnvironment(), showFeedbackPopUp: .constant(true), selectedEmotion: .constant("Happy"), star: .constant(0), currentActivity: Activity(), colorTheme: .greenColor)
//            .frame(width: 0.6*UIScreen.main.bounds.height, height: 0.6*UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
//            .environment(\.horizontalSizeClass, .compact)
//            .environment(\.verticalSizeClass, .compact)
//    }
//}
