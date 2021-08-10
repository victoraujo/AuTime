//
//  PremiumActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 27/07/21.
//

import SwiftUI

struct PremiumActivityView: View {
    var starsCompleted: [Bool] = [true, false, false]
    var activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack (alignment: .center){
                HStack {
                    ForEach(self.starsCompleted, id: \.self) { complete in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 0.35*geometry.size.height, height: 0.35*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(complete ? .greenColor : .grayColor)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading){
                    Text(activity.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.greenColor)
                    
                    Text("Premium Activity")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black90Color)
                }
                
            }
            .cornerRadius(21, [.topLeft, .topRight])
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct PremiumActivityView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumActivityView(activity: Activity(id: "", category: "Prêmio", complete: Date(), generateStar: true, name: "Premiozinho", repeatDays: [1,2], time: Date(), stepsCount: 0))
            .frame(width: 375, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}
