//
//  WeekActivitiesView.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/07/21.
//

import SwiftUI

struct WeekActivitiesView: View {
        
    @ObservedObject var activitiesManager = ActivityViewModel.shared
        
    func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let days = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        
        return days[weekDay-1] + ", " + dateFormatter.string(from: date)
    }
    
    func addNumberOfDaysToDate(date: Date, count: Int) -> Date {
        let newComponent = DateComponents(day: count)
        guard let newDate = Calendar.current.date(byAdding: newComponent, to: date) else {
            return date
        }
        return newDate
    }
    
    func dayWeekIndex(offset: Int) -> Int {
        let newDate = addNumberOfDaysToDate(date: Date(), count: offset)
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: newDate)
        
        return weekDay - 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false){
                VStack {
                    ForEach(0..<7, id: \.self) { dayCount in
                        VStack (alignment: .leading){
                            Text(getDateString(from: addNumberOfDaysToDate(date: Date(), count: dayCount)))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black100Color)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack (alignment: .center, spacing: 0.025*geometry.size.width){
                                    ForEach(self.activitiesManager.weekActivities[self.dayWeekIndex(offset: dayCount)], id: \.self) { activity in
                                        ActivityWeekView(name: activity.name)
                                    }
                                }
                                .frame(minHeight: 210, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .padding(.vertical)
                            }
                        }
                        .frame(width: geometry.size.width, alignment: .center)
                    }
                }
            }
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
        VStack {
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(width: 0.18*UIScreen.main.bounds.width, height: 0.018*UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Text(name)
                .foregroundColor(.greenColor)
                .font(.body)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 21))
        .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
        .onAppear {
            self.image = self.imageManager.imageView.image ?? UIImage()
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
