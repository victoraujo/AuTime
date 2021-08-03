//
//  ParentView.swift
//  AuTime
//
//  Created by Victor Vieira on 30/07/21.
//

import SwiftUI

struct ParentView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @Binding var showContentView: Bool
    @State var visualization: ParentViewMode = .create
    
    public enum ParentViewMode: Int {
        case create, schedule, weeks, activities, tutorial
    }
    
    var body: some View {
        GeometryReader{ geometry in
            
            HStack {
                SideBarParentView(showContentView: $showContentView, visualization: $visualization)
                    .frame(width: geometry.size.width * 0.27, alignment: .leading)
                
                Spacer()
                
                if visualization == .create {
                    Text("Criar")
                }
                else if visualization == .schedule {
                    ScheduleView()
                }
                else if visualization == .weeks {
                    Text("Semanas")
                }
                else if visualization == .activities {
                    Text("Todas atividades")
                }
                else if visualization == .tutorial {
                    Text("Tutoriais")
                }
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(showContentView: .constant(true))
            .previewLayout(.fixed(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}
