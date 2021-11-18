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
            ZStack {
                NavigationView{
                    NativeSideBarView(env: env)
                    ScheduleView(_env: _env)
                }.accentColor(env.parentColorTheme)
                
                // Change Profile Pop-Up
                VStack(alignment: .center) {
                    ChangeProfileView(env: _env)
                        .frame(width: 0.5*geometry.size.width, height: 0.5*geometry.size.height, alignment: .center)
                        .opacity(env.isShowingChangeProfile ? 1 : 0)
                }
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark))
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .opacity((env.isShowingChangeProfile ? 1 : 0))
                                .edgesIgnoringSafeArea(.all))                

            }
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
