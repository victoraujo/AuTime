//
//  WeekActivitiesView.swift
//  AuTime
//
//  Created by Matheus Andrade on 30/07/21.
//

import SwiftUI

struct WeekActivitiesView: View {
    
    let subs = ["lavar mao", "comer", "lavar prato", "tomar banho", ]
    
    func getDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        let days = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"]
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        
        return days[weekDay-1] + ", " + dateFormatter.string(from: date)
    }
    
    func addNumberOfDaysToDate(date: Date, count: Int) -> Date{
        let newComponent = DateComponents(day: count)
        guard let newDate = Calendar.current.date(byAdding: newComponent, to: date) else {
            return date
        }
        return newDate
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical){
                VStack (alignment: .leading){
                    Text("oi")
                    
                    ForEach(0..<7, id: \.self) { dayCount in
                        Text(getDate(from: addNumberOfDaysToDate(date: Date(), count: dayCount)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical)
                        
                        ScrollView(.horizontal) {
                            HStack (alignment: .center){
                                ForEach(self.subs, id: \.self) { sub in
                                    Text(sub)
                                        .font(.title)
                                    
                                }
                            }
                        }
                    }
                }
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
