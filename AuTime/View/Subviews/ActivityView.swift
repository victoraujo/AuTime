//
//  ActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 20/07/21.
//

import SwiftUI

struct ActivityView: View {
    var activityName: String = "Café da manhã"
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Image(uiImage: UIImage(imageLiteralResourceName: "breakfast"))
                    .resizable()
                    .clipped()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 0.7*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(21, [.topRight, .topLeft])
                
                HStack(alignment: .center){
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(.greenColor)
                        .frame(width: 0.1*geometry.size.width, height: 0.1*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                        
                    VStack(alignment: .leading){
                        Text(activityName)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.greenColor)
                        
                        Text("Numero de subtarefas")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black90Color)
                    }
                    
                }
                .padding(.vertical, 12)
            }
            .cornerRadius(21)
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
            .frame(width: 314, height: 252, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
