//
//  ChangeProfileSheet.swift
//  AuTime
//
//  Created by Matheus Andrade on 26/11/21.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var env: AppEnvironment
    @ObservedObject var userManager: UserViewModel = UserViewModel.shared
    
    @State var parentName: String = ""
    @State var childName: String = ""
    @State var parentEmail: String = ""
    @State var showEmptyFieldAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                VStack{
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(uiImage: env.parentPhoto)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width*0.075, height: UIScreen.main.bounds.width*0.075, alignment: .center)
                                .padding()
                                .clipShape(Circle())
                            
                            Text("\(env.parentName)")
                                .font(.title3)
                                .bold()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Image(uiImage: env.childPhoto)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width*0.075, height: UIScreen.main.bounds.width*0.075, alignment: .center)
                                .padding()
                                .clipShape(Circle())
                            
                            Text("\(env.childName)")
                                .font(.title3)
                                .bold()
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    List {
                        Section{
                            NavigationLink(destination: {
                                VStack {
                                    Form {
                                        Section(header: Text("Parent Name"), content: {
                                            TextField("Parent Name", text: $parentName)
                                        })
                                        
                                        Section(header: Text("Child Name"), content: {
                                            TextField("Child Name", text: $childName)
                                        })
                                        
                                    }
                                }
                                .onDisappear {
                                    self.parentName = env.parentName
                                    self.childName = env.childName
                                }
                                .navigationTitle("Names")
                                .toolbar(content: {
                                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                                        Button(action: {
                                            if childName != "" && parentName != "" {
                                                env.updateProfile(childName: childName, parentName: parentName)
                                            } else {
                                                self.showEmptyFieldAlert = true
                                            }
                                        }, label: {
                                            Text("SAVE")
                                                .bold()
                                        })
                                            .alert(isPresented: $showEmptyFieldAlert) { () -> Alert in
                                                Alert(title: Text("Empty Fields"), message: Text("You must fill all the fields to change your profile informations"), dismissButton: .default(Text("OK")))
                                            }
                                    }
                                })
                            }, label: {
                                Text("Names")
                            })
                            
                            NavigationLink(destination: {
                                Text("Senhasss")
                            }, label: {
                                Text("Passwords")
                            })
                        }
                        
                        Section {
                            Button(action: {
                                env.isShowingProfileSettings = false
                                userManager.signOut()
                            }, label: {
                                Text("Sign Out")
                                    .foregroundColor(.blue)
                            })
                        }
                        
                        Section {
                            Button(action: {
                                env.isShowingProfileSettings = false
                                userManager.signOut()
                            }, label: {
                                Text("Delete Account")
                                    .foregroundColor(.red)
                            })
                        }
                    }
                    .frame(height: geometry.size.height*0.5, alignment: .center)
                    
                    Button(action: {
                        env.isShowingProfileSettings = false
                        env.changeProfile()
                    }, label: {
                        Text("Change Profile")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 0.4*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .background(env.parentColorTheme)
                            .cornerRadius(21)
                    })
                    
                    Spacer()
                }
                .listStyle(.insetGrouped)
                .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
                .toolbar(content: {
                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                        Button(action: {
                            env.isShowingProfileSettings = false
                        }, label: {
                            Text("OK")
                                .bold()
                        })
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                        Text("Profile")
                            .font(.title2)
                            .bold()
                    }
                })
            }
        }
        .accentColor(env.parentColorTheme)
        .onAppear {
            self.parentName = env.parentName
            self.childName = env.childName
        }
        .onDisappear {
            env.isShowingProfileSettings = false
        }
    }
}

