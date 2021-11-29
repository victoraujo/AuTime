//
//  ActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    
    @State var image: UIImage = UIImage()
    
    var activity: Activity
    var colorTheme: Color
    var IconImage: Image
    
    init(activity: Activity, colorTheme: Color) {
        self.activity = activity
        self.colorTheme = colorTheme
        self.IconImage = Activity.getIconImage(from: self.activity.category)
        
        if let email = userManager.session?.email {
            let filePath = "users/\(email)/Activities/\(activity.name)"
            self.imageManager.downloadImage(from: filePath)
        }
        
        self.image = self.imageManager.imageView.image ?? UIImage()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading){
                ZStack {
                    Image(uiImage: self.image)
                    .resizable()
                    .clipped()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 0.7*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(21, [.topRight, .topLeft])
                    .overlay(Color.black100Color.opacity( DateHelper.datesMatch(activity.lastCompletionDate(), Date()) ? 0.825 : 0).cornerRadius(21, [.topRight, .topLeft]))
                    
                    VStack(alignment: .center) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 0.05*UIScreen.main.bounds.height, alignment: .center)
                            .foregroundColor(.white)
                        
                        Text("Activity completed!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .opacity( DateHelper.datesMatch(activity.lastCompletionDate(), Date()) ? 1 : 0)
                    
                }
                
                HStack(alignment: .center){
                    IconImage
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
                        
                        Text("\(activity.stepsCount > 0 ? String(activity.stepsCount) : "No") subactivit\(activity.stepsCount > 1 ? "ies" : "y")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black90Color)
                    }
                }
                .padding(.leading, 30)
                .padding(.vertical, 12)
            }
            .cornerRadius(21)
        }
        .onAppear{
            self.image = self.imageManager.imageView.image ?? UIImage()
        }
        .onChange(of: imageManager.imageView.image, perform: { value in
            self.image = self.imageManager.imageView.image ?? UIImage()
        })
    }
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(activity: <#Activity#>, colorTheme: .greenColor)
//            .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//    }
//}
