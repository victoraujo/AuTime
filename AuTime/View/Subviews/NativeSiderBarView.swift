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
    
    var body: some View {
        
        List {
            NavigationLink(destination: ScheduleView(), label: {
                Label("Schedule", systemImage: "calendar")
            })
            
            NavigationLink(destination: ActivitiesLibraryView(), label: {
                Label("Activities Library", systemImage: "book")
            })
            
            Button(action: {
                env.profile = .child
            }, label: {
                Label("Change profile", systemImage: "person.crop.circle")
//                HStack{
//                    Image(systemName: "person.crop.circle")
//                        .foregroundColor(colorTheme)
//                        .padding()
//                    Text("Change profile")
//                }
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
