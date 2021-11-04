//
//  ActivitiesLibraryView.swift
//  AuTime
//
//  Created by Victor Vieira on 03/11/21.
//

import SwiftUI

struct ActivitiesLibraryView: View {
    @ObservedObject var activitiesVM = ActivityViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var imageManager = ImageViewModel()
    @State private var showingPopover = false
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack{
                    Text("Activities Library")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        showingPopover = true
                    }, label: {
                        Text("Create activity")
                    })
                        .padding()
                }
                SearchBar(text: .constant(""))
                ScrollView(.vertical){
                    HStack{
                        Text("All activities")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding([.top,.leading])
                        Spacer()
                    }
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(activitiesVM.activities){ activity in
                                VStack(alignment: .leading){
                                    ActivityImageView(name: activity.name).frame(width: geometry.size.width*0.3, height: geometry.size.height*0.2, alignment: . center)
                                    Text(activity.category)
                                        .foregroundColor(.gray)
                                    Text(activity.name)
                                        .font(.title3)
                                    Text("\(activity.stepsCount) steps")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                
                                
                            }
                        }
                        
                        
                    }.padding([.leading, .bottom])
                    
                    HStack{
                        Text("Health")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding([.top,.leading])
                        Spacer()
                    }
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(activitiesVM.activities.filter{ $0.category.elementsEqual("Saúde")}){ activity in
                                VStack(alignment: .leading){
                                    ActivityImageView(name: activity.name).frame(width: geometry.size.width*0.2, height: geometry.size.height*0.2, alignment: . center)
                                    Text(activity.name)
                                        .font(.title3)
                                    Text("\(activity.stepsCount) steps")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                
                                
                            }
                        }
                        
                        
                    }.padding([.leading, .bottom])
                    
                    HStack{
                        Text("Education")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding([.top,.leading])
                        Spacer()
                    }
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(activitiesVM.activities.filter{ $0.category.elementsEqual("Educação")}){ activity in
                                VStack(alignment: .leading){
                                    ActivityImageView(name: activity.name).frame(width: geometry.size.width*0.2, height: geometry.size.height*0.2, alignment: . center)
                                    Text(activity.name)
                                        .font(.title3)
                                    Text("\(activity.stepsCount) steps")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                
                                
                            }
                        }
                        
                        
                    }.padding([.leading, .bottom])
                    
                    Spacer()
                }
                
            }
            .sheet(isPresented: $showingPopover){
                NewActivity(showingPopover: $showingPopover)
            }
        }
    }
}

struct NewActivity: View{
    @Binding var showingPopover: Bool
    @State private var selectedCategory = "Health"
    @State var activityImage = UIImage(named: "Breakfast") ?? UIImage()
    @State var isShowingPhotoPicker = false
    let categories = ["Health", "Education", "Family"]
    
    
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
                                isShowingPhotoPicker = true
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
        }
    }
}

struct ActivityImageView: View {
    
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    
    @State var image: UIImage = UIImage()
    var name: String
    
    init(name: String) {
        self.name = name
        
        if let email = userManager.session?.email {
            let filePath = "users/\(email)/Activities/\(self.name)"
            self.imageManager.downloadImage(from: filePath)
        }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(uiImage: self.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

//                Text(name)
//                    .foregroundColor(.greenColor)
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .padding()
//                    .frame(width: geometry.size.width, height: 0.3*geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                    .padding(.top)

            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            //.background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
            .onAppear {
                self.image = self.imageManager.imageView.image ?? UIImage()
            }
        }
    }
}


struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
