//
//  ParentView.swift
//  AuTime
//
//  Created by Victor Vieira on 30/07/21.
//

import SwiftUI

struct ParentView: View {
    @Binding var showContentView: Bool
    @ObservedObject var userManager = UserViewModel.shared
    var body: some View {
        GeometryReader{ geometry in
            
            SideBarParentView(showContentView: $showContentView)
                .frame(width: geometry.size.width * 0.27, alignment: .leading)
        }
        
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(showContentView: .constant(true))
    }
}
