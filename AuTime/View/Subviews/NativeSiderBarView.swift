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
    @ObservedObject var profileManager: ProfileViewModel = ProfileViewModel.shared
    
    init(_env: ObservedObject<AppEnvironment>) {
        self._env = _env
    }
    
    var body: some View {
        
        List {
            NavigationLink(destination: ScheduleView(_env: _env), label: {
                Label("Cronograma de \(profileManager.getChildName())", systemImage: "calendar")
            })
            
            Section(header: Text("Atividades"), content: {
                
                NavigationLink(destination: ActivitiesLibraryView(env: env), label: {
                    Text("Todas Atividades")
                })
                
                ForEach(env.categories, id: \.self) { category in
                    NavigationLink(destination: ActivitiesByCategoryView(env: env, category: category, activities: activitiesManager.getActivitiesByCategory(category: category)), label: {
                        //Label("\(category)", systemImage: "")
                        Text("\(category)")
                    })
                }
                
            })
        }
        .navigationTitle("Tela de \(profileManager.getParentName())")
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
        .onDisappear {
            env.isShowingProfileSettings = false
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    env.isShowingProfileSettings = true
                }, label: {
                    Image(systemName: "person.circle")
                })
            }
        }        
    }
}
