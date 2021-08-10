//
//  FeedbackChildView.swift
//  AuTime
//
//  Created by Matheus Andrade on 09/08/21.
//

import SwiftUI

struct FeedbackChildView: View {
    
    let emotions: [String] = ["Upset", "Sad", "Happy", "Joyful"]
    
    @Binding var showFeedbackPopUp: Bool
    @Binding var selectedEmotion: String
    
    var colorTheme: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack (alignment: .center) {
                    
                    Spacer()
                    
                    Text("John, how are you feeling?")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black100Color)
                        .multilineTextAlignment(.leading)
                        .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    HStack(alignment: .top){
                        ForEach(emotions, id: \.self) { emotion in
                            VStack(alignment: .center) {
                                Image("\(emotion)")
                                    .resizable()
                                    .frame(width: 0.15*geometry.size.width, height: 0.15*geometry.size.width, alignment: .center)
                                    .padding()
                                    .background( emotion == selectedEmotion ?
                                                    colorTheme
                                                    :
                                                    Color.clear
                                    )
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
                    
                    Spacer()
                    
                    VStack(alignment: .center){
                        
                        Button(action: {
                            self.showFeedbackPopUp = false
                        }, label: {
                            Text("Confirm")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 0.3*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .background(colorTheme)
                                .cornerRadius(21)
                        })
                        
                        .padding()
                                                
                        Button(action: {
                            self.selectedEmotion = ""
                            self.showFeedbackPopUp = false
                        }, label: {
                            Text("Skip")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(colorTheme)
                            
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

struct FeedbackChildView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackChildView(showFeedbackPopUp: .constant(true), selectedEmotion: .constant("Happy"), colorTheme: .greenColor)
            .frame(width: 0.6*UIScreen.main.bounds.height, height: 0.6*UIScreen.main.bounds.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}
