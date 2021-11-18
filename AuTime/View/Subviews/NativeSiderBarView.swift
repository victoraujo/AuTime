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
    var colorTheme: Color = .blue
    
    let categories: [String] = ["Education", "Health"]
    
    var body: some View {
        
        List {
            NavigationLink(destination: ScheduleView(_env: _env), label: {
                Label("Schedule", systemImage: "calendar")
            })
            
            Section(header: Text("Activities"), content: {
                
                NavigationLink(destination: ActivitiesLibraryView(), label: {
                    Label("Activities Library", systemImage: "books.vertical")
                })
                
                ForEach(categories, id: \.self) { category in
                    NavigationLink(destination: ActivitiesLibraryView(), label: {
                        Label("\(category)", systemImage: Activity.getSystemImage(from: category))
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
                    env.isShowingChangeProfile = true
                    // env.isShowingProfileSettings = true
                }, label: {
                    Image(systemName: "person.circle")
                })
            }
        }
    }
}

struct NativeSideBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NativeSideBarView(env: AppEnvironment())
                .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
                .environment(\.horizontalSizeClass, .compact)
                .environment(\.verticalSizeClass, .compact)
            
        }
    }
}
