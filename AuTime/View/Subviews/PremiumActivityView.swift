//
//  PremiumActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 27/07/21.
//

import SwiftUI

struct PremiumActivityView: View {
    var starsCompleted: [Bool] = [false, false, false]
    var activity: Activity
    @Binding var starCount: Int
    
    init(activity: Activity, starCount: Binding<Int>) {
        self.activity = activity
        self._starCount = starCount
        
        for index in 0..<starsCompleted.count {
            if starCount.wrappedValue > index {
                starsCompleted[index] = true
            }
        }
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
                            .animation(.easeIn(duration: 1))
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading){
                    Text(activity.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.greenColor)
                    
                    Text("Atividade Prêmio")
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

//struct PremiumActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        PremiumActivityView(activity: Activity(id: "", category: "Prêmio", complete: [Date(), "Happy"], generateStar: true, name: "Premiozinho", repeatDays: [1,2], time: Date(), stepsCount: 0), starCount: .constant(0))
//            .frame(width: 375, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
//            .environment(\.horizontalSizeClass, .compact)
//            .environment(\.verticalSizeClass, .compact)
//    }
//}
