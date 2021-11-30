//
//  ActivityImageView.swift
//  AuTime
//
//  Created by Matheus Andrade on 19/11/21.
//

import SwiftUI

struct ActivityImageView: View {
    
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    
    @State var image: UIImage = UIImage()
    var name: String
    
    init(name: String) {
        self.name = name
        
        if let email = userManager.session?.email {
            let filePath = "users/\(email)/Activities/\(self.name)"
            self.imageManager.downloadImage(from: filePath){}
        }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(uiImage: self.imageManager.imageView.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear {
                self.image = self.imageManager.imageView.image ?? UIImage()
            }
        }
    }
}
