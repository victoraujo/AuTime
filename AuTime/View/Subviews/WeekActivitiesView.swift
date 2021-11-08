//
//  WeekActivitiesView.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/07/21.
//

import SwiftUI

struct WeekActivitiesView: View {
    
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false){
                VStack (alignment: .leading){
                    ForEach(0..<7, id: \.self) { dayCount in
                        Text(DateHelper.getDateString(from: DateHelper.addNumberOfDaysToDate(date: Date(), count: dayCount)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .foregroundColor(.black100Color)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (alignment: .center, spacing: 0.025*geometry.size.width){
                                ForEach(self.activitiesManager.weekActivities[DateHelper.dayWeekIndex(offset: dayCount)], id: \.self) { activity in
                                    ActivityWeekView(name: activity.name)
                                        .frame(width: 0.2*geometry.size.width, height: 0.32*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .padding(.bottom)
                                    
                                }
                            }
                        }
                        .padding([.vertical, .leading])
                    }
                }
            }
            .padding(.bottom, 30)
        }
    }
}


struct ActivityWeekView: View {
    
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    
    @State var image: UIImage = UIImage()
    var name: String
    
    init(name: String) {
        self.name = name
        
        if let email = userManager.session?.email {
            let filePath = "users/\(email)/Activities/\(self.name)"
            self.imageManager.downloadImage(from: filePath)
        }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(uiImage: self.imageManager.imageView.image ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 0.6*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Text(name)
                    .foregroundColor(.greenColor)
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: geometry.size.width, height: 0.3*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.top)

            }
            .clipShape(RoundedRectangle(cornerRadius: 21))
            .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
            .onAppear {
                self.image = self.imageManager.imageView.image ?? UIImage()
            }
        }
    }
}

struct WeekActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        WeekActivitiesView()
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}
