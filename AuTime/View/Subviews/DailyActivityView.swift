//
//  DailyActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 25/11/21.
//

import SwiftUI

struct DailyActivityView: View {
    
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    
    @State var image: UIImage = UIImage()
    
    var activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
        
        if let email = userManager.session?.email {
            let filePath = "users/\(email)/Activities/\(activity.name)"
            self.imageManager.downloadImage(from: filePath)
        }
        
        self.image = self.imageManager.imageView.image ?? UIImage()
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top){
                Image(uiImage: self.image)
                    .resizable()
                    .clipped()
                    .scaledToFill()
                    .frame(width: geometry.size.width*0.3, height: geometry.size.height, alignment: .center)
                    .cornerRadius(21)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(activity.category.uppercased())
                        .font(.headline)
                        .foregroundColor(.black90Color)
                        .bold()
                    Text(activity.name)
                        .font(.title)
                        .bold()
                    
                    Text("\(activity.stepsCount) steps")
                        .font(.subheadline)
                        .foregroundColor(.black90Color)
                    
                    Divider()
                    
                    Spacer()
                    
                    HStack (alignment: .center){
                        Text("⏱")
                            .font(.system(size: 0.04*geometry.size.width))
                            .padding(.trailing)
                        
                        VStack (alignment: .leading){
                            Text("TIME SET")
                                .foregroundColor(.black90Color)
                                .font(.callout)
                                .fontWeight(.regular)
                            
                            Text("\(DateHelper.getHoursAndMinutes(from: activity.time))")
                                .foregroundColor(.black100Color)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.bottom)
                    
                    HStack (alignment: .center){
                        Text("⏰")
                            .font(.system(size: 0.04*geometry.size.width))
                            .padding(.trailing)
                        
                        VStack (alignment: .leading){
                            Text("CONCLUSION TIME")
                                .foregroundColor(.black90Color)
                                .font(.callout)
                                .fontWeight(.regular)
                            
                            Text("\(DateHelper.getHoursAndMinutes(from: activity.lastCompletionDate()))")
                                .foregroundColor(.black100Color)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .opacity(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? 1 : 0)
                    .padding(.bottom)
                    
                    HStack (alignment: .center){
                        Text("\(Activity.getFeedbackEmoji(from: activity.lastCompletionFeedback()))")
                            .font(.system(size: 0.04*geometry.size.width))
                            .padding(.trailing)
                        
                        VStack (alignment: .leading){
                            Text("EMOTION FEEDBACK")
                                .foregroundColor(.black90Color)
                                .font(.callout)
                                .fontWeight(.regular)
                            
                            Text("\(activity.lastCompletionFeedback())")
                                .foregroundColor(.black100Color)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .opacity(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? 1 : 0)
                    .padding(.bottom)
                    
                    Spacer()
                    
                }
            }
        }
        .onAppear{
            self.image = self.imageManager.imageView.image ?? UIImage()
        }
        .onChange(of: imageManager.imageView.image, perform: { value in
            self.image = self.imageManager.imageView.image ?? UIImage()
        })
    }
}
