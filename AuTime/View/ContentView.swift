//
//  ContentView.swift
//  AuTime
//
//  Created by Victor Vieira on 19/07/21.
//

import SwiftUI

// TO DELETE

struct ContentView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var activitiesManager = ActivityViewModel.shared
    @ObservedObject var subActivitiesManager = SubActivityViewModel()
    @ObservedObject var imageVM = ImageViewModel()
    
    @State var showSubActivitiesView = false
    @Binding var showContentView: Bool
    
    @State var image = UIImage()
    
    let imageName = "Wash hands"
    
    init(show: Binding<Bool>) {
        self._showContentView = show
        self.imageVM.downloadImage(from: "users/\(String(describing: userManager.session?.email))/Activities/ocapi")
        
        var photo: UIImage!
        
        if let data = self.imageVM.imageView.image?.pngData() {
            photo = UIImage(data: data)
        } else {
            photo = UIImage()
        }
        
        self.image = photo
    }
    
    var body: some View {
        VStack{
            
            List(activitiesManager.todayActivities){ activity in
                Text(activity.name)
                    .onTapGesture {
                        subActivitiesManager.activityReference = activity.id!
                        showSubActivitiesView.toggle()
                    }
            }
            Image(uiImage: self.image)
            Button(action: {
                activitiesManager.createActivity(category: "Teste", completions: [Completion(date: Date(), feedback: "Joyful")], star: true, name: "Zaga", days: [1, 2, 4, 6], steps: 0, time: Date(), handler: {})
            }, label: {
                Text("ADD ACTIVITY")
            })
            .padding()
            
            Button(action: {
                showContentView = false
                userManager.signOut()
            }, label: {
                Text("DESLOGAR")
                    .foregroundColor(.red)
            })
            .padding()
            
            Button(action: {
                guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("ocapi") else {
                    return
                }
                // Save image to URL
                do {
                    if let email = userManager.session?.email{
                        try UIImage(named: "\(imageName)")!.pngData()?.write(to: imageURL)
                        imageVM.uploadImage(urlFile: imageURL, filePath: "users/\(email)/SubActivities/\(imageName)")
                    }
                    
                } catch { }
            }, label: {
                Text("UPLOAD")
                    .foregroundColor(.red)
            })
            .padding()
            
            Button(action: {
                let _ = imageVM.downloadImage(from: "users/\(String(describing: userManager.session?.email))/SubActivities/ocapi")
            }, label: {
                Text("DOWNLOAD")
                    .foregroundColor(.red)
            })
            .padding()
        }
        
        .onAppear(perform: {
            self.activitiesManager.fetchData()
            
            var photo: UIImage!
            
            if let data = self.imageVM.imageView.image?.pngData() {
                photo = UIImage(data: data)
            } else {
                photo = UIImage()
            }
            
            self.image = photo
        })
        //.fullScreenCover(isPresented: $showSubActivitiesView){ SubActivitiesView()
        //}
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(show: .constant(true))
    }
}
