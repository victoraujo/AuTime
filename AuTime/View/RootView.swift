//
//  RootView.swift
//  AuTime
//
//  Created by Matheus Andrade on 03/11/21.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var env = AppEnvironment()
    @ObservedObject var userManager = UserViewModel.shared
    
    var body: some View {
        
        if !userManager.isVerified() {
            SignView().ignoresSafeArea()
        } else if env.profile == .child {
            ChildView(env: env)
        } else {
            ParentView(env: env)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            RootView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            // Fallback on earlier versions
        }
    }
}

