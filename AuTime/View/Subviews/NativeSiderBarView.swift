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
            Button(action:{
                env.scheduleIsOpen.toggle()
            }){
                HStack{
                    Text("Schedule")
                        .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.init(degrees: env.scheduleIsOpen ? 90.0 : 0))
                        .animation(.spring())
                    
                }
            }
            .padding(.vertical)
            .foregroundColor(.primary)
            
            Group{
                if env.scheduleIsOpen {
                    NavigationLink(destination: ScheduleView()) {
                        Text("Today")
                    }
                    
                    NavigationLink(destination: ScheduleView()) {
                        Text("Week")
                    }
                }
            }
            .padding(.leading)
            .font(Font.headline.weight(.regular))
            
            NavigationLink(destination: ScheduleView()){
                HStack{
                    Text("Activities")
                        .bold()
                    Spacer()
                }
                .font(Font.headline.weight(.regular))
                .foregroundColor(.primary)
            }
            
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
