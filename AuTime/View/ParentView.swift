//
//  ParentView.swift
//  AuTime
//
//  Created by Victor Vieira on 30/07/21.
//

import SwiftUI

struct ParentView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @State var visualization: ParentViewMode = .schedule
    @Binding var showChildView: Bool
    @Binding var showParentView: Bool
    
    public enum ParentViewMode: Int {
        case schedule, create, weeks, activities, tutorial
    }
    
    var body: some View {
        GeometryReader{ geometry in
            
            HStack {
                SideBarParentView(visualization: $visualization, showChildView: $showChildView, showParentView: $showParentView)
                    .frame(width: geometry.size.width * 0.27, alignment: .leading)
                
                Spacer()
                
                if visualization == .schedule {
                    ScheduleView()
                }
                else if visualization == .create {
                    CreateActivityView()
                }    
                else if visualization == .weeks {
                    Text("Weeks")
                }
                else if visualization == .activities {
                    Text("All activities")
                }
                else if visualization == .tutorial {
                    Text("Tutorials")
                }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(showChildView: .constant(false), showParentView: .constant(true))
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}
