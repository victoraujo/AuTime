//
//  ParentView.swift
//  AuTime
//
//  Created by Victor Vieira on 30/07/21.
//

import SwiftUI

struct ParentView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var env: AppEnvironment
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView{
                NativeSideBarView(env: env)
                ScheduleView()
            }
            .toolbar(content: {
                ToolbarItem(content: {
                    
                })
            })
            
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(env: AppEnvironment())
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}
