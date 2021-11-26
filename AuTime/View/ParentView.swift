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
    
    @State var isShowingProfileSettings: Bool = false
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView{
                NativeSideBarView(_env: _env)
                ScheduleView(_env: _env)
            }
            .accentColor(env.parentColorTheme)
            .sheet(isPresented: $isShowingProfileSettings, content: {
                ProfileView(env: env)
            })
            .onChange(of: env.isShowingProfileSettings, perform: { value in
                self.isShowingProfileSettings = value
                
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
