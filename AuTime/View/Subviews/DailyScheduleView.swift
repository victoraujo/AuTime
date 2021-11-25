//
//  DailyScheduleView.swift
//  AuTime
//
//  Created by Matheus Andrade on 23/11/21.
//

import SwiftUI

struct DailyScheduleView: View {
    @ObservedObject var activitiesManager: ActivityViewModel = ActivityViewModel.shared
    @ObservedObject var env: AppEnvironment
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(self.activitiesManager.todayActivities, id: \.self) { activity in
                    VStack {
                        DailyActivityView(activity: activity)
                            .frame(width: geometry.size.width, height: geometry.size.width*0.425, alignment: .center)
                            .padding()
                    }
                    
                }
            }
        }
    }
}

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
                        .font(.subheadline)
                        .foregroundColor(.black90Color)
                        .bold()
                    Text(activity.name)
                        .font(.title3)
                        .bold()
                    
                    Text("\(activity.stepsCount) steps")
                        .font(.body)
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
//
//struct old: View {
//    var body: some View {
//        ScrollView(.vertical) {
//            VStack(alignment: .center, spacing: 0.05*UIScreen.main.bounds.height){
//
//                ForEach(Array(self.activitiesManager.todayActivities.enumerated()), id: \.offset) {  index, activity in
//                    HStack(alignment: .center) {
//
//                        Spacer()
//
//                        Text("\(DateHelper.getHoursAndMinutes(from: activity.time))")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .foregroundColor(.black90Color)
//                            .padding(.vertical)
//
//                        Spacer()
//
//                        ActivityView(activity: activity, colorTheme: env.parentColorTheme)
//                            .frame(width: UIScreen.main.bounds.width*0.3, height: UIScreen.main.bounds.height*0.3, alignment: .center)
//                            .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
//                            .padding()
//
//                        Spacer()
//
//                        VStack(alignment: .leading) {
//                            HStack (alignment: .center){
//                                Text("⏰")
//                                    .font(.system(size: 0.04*geometry.size.width))
//                                    .padding()
//                                    .opacity(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? 1 : 0)
//
//                                VStack (alignment: .leading){
//                                    Text("Completion time")
//                                        .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? .black90Color : .clear)
//                                        .font(.callout)
//                                        .fontWeight(.regular)
//
//                                    Text(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? "\(DateHelper.getHoursAndMinutes(from: activity.lastCompletionDate()))" : "")
//                                        .foregroundColor(.black100Color)
//                                        .font(.title3)
//                                        .fontWeight(.bold)
//                                }
//                            }
//
//                            HStack (alignment: .center){
//                                Activity.getFeedbackEmoji(from: activity.lastCompletionFeedback())
//                                    .font(.system(size: 0.04*geometry.size.width))
//                                    .padding()
//                                    .opacity(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? 1 : 0)
//
//                                VStack (alignment: .leading){
//                                    Text("Emotion feedback")
//                                        .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? .black90Color : .clear)
//                                        .font(.callout)
//                                        .fontWeight(.regular)
//
//                                    Text(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? activity.lastCompletionFeedback() : "")
//                                        .foregroundColor(DateHelper.datesMatch(Date(), activity.lastCompletionDate()) ? .black100Color : .clear)
//                                        .font(.title3)
//                                        .fontWeight(.bold)
//                                }
//                            }
//
//                        }
//                        .padding()
//
//                        Spacer()
//
//                    }
//                    .id(index)
//                }
//
//                Rectangle()
//                    .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .foregroundColor(.clear)
//            }
//            .padding()
//        }
//    }
//}
