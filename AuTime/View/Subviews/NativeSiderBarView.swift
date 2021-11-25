//
//  NativeSiderBarView.swift
//  AuTime
//
//  Created by Matheus Andrade on 03/11/21.
//

import SwiftUI
import UIKit

struct NativeSideBarView: View {
    @ObservedObject var env: AppEnvironment
    @ObservedObject var activitiesManager: ActivityViewModel = ActivityViewModel.shared
    
    @State var showProfileSheet: Bool = false
    
    init(_env: ObservedObject<AppEnvironment>) {
        self._env = _env
    }
    
    var body: some View {
        
        List {
            NavigationLink(destination: ScheduleView(_env: _env), label: {
                Label("\(env.childName)'s Schedule", systemImage: "calendar")
            })
            
            Section(header: Text("Activities"), content: {
                
                NavigationLink(destination: ActivitiesLibraryView(env: env), label: {
                    //Label("All Activities", systemImage: "")
                    Text("All Activities")
                })
                
                ForEach(env.categories, id: \.self) { category in
                    NavigationLink(destination: ActivitiesByCategoryView(category: category, activities: activitiesManager.getActivitiesByCategory(category: category)), label: {
                        //Label("\(category)", systemImage: "")
                        Text("\(category)")
                    })
                }
                
            })
        }
        .navigationTitle("Parent's View")
        .listStyle(SidebarListStyle())
        .onAppear {
            let rootViewController = UIApplication.shared.windows.first { $0.isKeyWindow }!.rootViewController
            guard
                let splitViewController = rootViewController?.children.first as? UISplitViewController,
                let sidebarViewController = splitViewController.viewController(for: .primary) else {
                    return
                }
            let tableView = UITableView.appearance(whenContainedInInstancesOf: [type(of: sidebarViewController)])
            tableView.backgroundColor = UIColor(Color.white)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showProfileSheet = true
                }, label: {
                    Image(systemName: "person.circle")
                })
            }
        }
        .sheet(isPresented: $showProfileSheet, content: {
            ChangeProfileSheet(env: env, showProfileSheet: $showProfileSheet)
        })
    }
}

struct ChangeProfileSheet: View {
    @ObservedObject var env: AppEnvironment
    @ObservedObject var userManager: UserViewModel = UserViewModel.shared

    @Binding var showProfileSheet: Bool
    
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
                                Text("Nomessss")
                            }, label: {
                                Text("Names, E-mail")
                            })
                            
                            NavigationLink(destination: {
                                Text("Senhasss")
                            }, label: {
                                Text("Passwords")
                            })
                        }
                        
                        Section {
                            Button(action: {
                                self.showProfileSheet = false
                                userManager.signOut()
                            }, label: {
                                Text("Sign Out")
                                    .foregroundColor(.blue)
                            })
                        }
                        
                        Section {
                            Button(action: {
                                self.showProfileSheet = false
                                userManager.signOut()
                            }, label: {
                                Text("Delete Account")
                                    .foregroundColor(.red)
                            })
                        }
                    }
                    .frame(height: geometry.size.height*0.5, alignment: .center)
                    
                    Button(action: {
                        self.showProfileSheet = false
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
                            self.showProfileSheet = false
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
        }.accentColor(env.parentColorTheme)
    }
}
