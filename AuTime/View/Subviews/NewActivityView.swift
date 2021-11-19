//
//  NewActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 19/11/21.
//

import SwiftUI
import Photos

struct NewActivity: View {
    @Binding var showingPopover: Bool
    @State private var selectedCategory = "Health"
    @State var activityImage = UIImage(named: "Breakfast") ?? UIImage()
    @State var isShowingPhotoPicker = false
    @State var isShowingAccessDeniedAlert = false
    let categories = ["Health", "Education", "Family"]
    let alertMessage = String(describing: Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription")!) + " Go to Settings and allow AuTime to access your photos."
    
    var body: some View{
        
        GeometryReader{ geometry in
            VStack{
                HStack{
                    Button(action: {showingPopover.toggle()}, label: {Text("Cancel")})
                        .padding()
                    Spacer()
                    Text("New Activity")
                        .font(.title3)
                        .padding()
                    Spacer()
                    Button(action: {showingPopover.toggle()}, label: {Text("Add")})
                        .padding()
                }
                TextField("title", text: .constant(""))
                    .padding()
                    .padding(.horizontal)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Form {
                    Section {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    Text("Generate Star")
                    Section{
                        HStack{
                            Spacer()
                            Image(uiImage: activityImage)
                                .resizable()
                                .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.3)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(21)
                                .padding()
                                .onTapGesture {
                                    let photos = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                                                                        
                                    // TO DO: Separate access for limited and authorized
                                    if photos == .limited || photos == .authorized {
                                        isShowingPhotoPicker = true
                                        isShowingAccessDeniedAlert = false
                                    }
                                    else {
                                        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                            
                                            // TO DO: Separate access for limited and authorized
                                            if status == .limited || status == .authorized {
                                                isShowingPhotoPicker = true
                                                isShowingAccessDeniedAlert = false
                                            }
                                            else {
                                                isShowingPhotoPicker = false
                                                isShowingAccessDeniedAlert = true
                                            }
                                        })
                                    }
                                }
                            Spacer()
                        }
                    }.onTapGesture {
                        isShowingPhotoPicker = true
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $isShowingPhotoPicker, content: {
                PhotoPicker(activityImage: $activityImage)
            })
            .alert(isPresented: $isShowingAccessDeniedAlert) { () -> Alert in
                Alert(title: Text("AuTime Would Like to Access Your Photos"), message: Text(self.alertMessage), primaryButton: .default(Text("Cancel")), secondaryButton: .default(Text("Go to Settings"), action: {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                    
                }))
            }
        }
    }
}
