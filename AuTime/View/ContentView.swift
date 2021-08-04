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
    @ObservedObject var subActivitiesManager = SubActivityViewModel.shared
    @ObservedObject var imageVM = ImageViewModel.shared
    
    @State var showSubActivitiesView = false
    @Binding var showContentView: Bool
    
    @State var image = UIImage()
    
    init(show: Binding<Bool>) {
        self._showContentView = show
        self.imageVM.downloadImage()
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
            Image(uiImage: imageVM.image.image ?? UIImage())
            Button(action: {
                activitiesManager.createActivity(category: "Teste", complete: Date(), star: true, name: "Zaga", days: [1, 2, 4, 6], time: Date(), handler: {})
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
                    try UIImage(named: "ocapi")!.pngData()?.write(to: imageURL)
                    imageVM.uploadImage(urlFile: imageURL)
                } catch { }
            }, label: {
                Text("UPLOAD")
                    .foregroundColor(.red)
            })
            .padding()
            
            Button(action: {
                imageVM.downloadImage()
            }, label: {
                Text("DOWNLOAD")
                    .foregroundColor(.red)
            })
            .padding()
        }
        
        .onAppear(perform: {
            self.activitiesManager.fetchData()
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
