//
//  ActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct ActivityView: View {
    var activity: Activity
    var subActivitiesCount: Int = 5
    var colorTheme: Color
    
    func getIconImage() -> Image{
        switch self.activity.category {
        case "Prêmio":
            return Image(systemName: "star.fill")
        default:
            return Image(systemName: "heart.fill")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading){
                Image(uiImage: UIImage(imageLiteralResourceName: "breakfast"))
                    .resizable()
                    .clipped()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 0.7*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(21, [.topRight, .topLeft])
                
                HStack(alignment: .center){
                    self.getIconImage()
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(colorTheme)
                        .frame(width: 0.1*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                        
                    VStack(alignment: .leading){
                        Text(self.activity.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(colorTheme)
                        
                        Text("\(subActivitiesCount > 0 ? String(subActivitiesCount) : "Nenhuma") subtarefa\(subActivitiesCount > 1 ? "s" : "")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black90Color)
                    }
                }
                .padding(.leading)
                .padding(.vertical, 12)
            }
            .cornerRadius(21)
        }
    }
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(activity: <#Activity#>, colorTheme: .greenColor)
//            .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//    }
//}
