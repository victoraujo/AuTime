//
//  ActivitiesByCategory.swift
//  AuTime
//
//  Created by Matheus Andrade on 19/11/21.
//

import SwiftUI

struct ActivitiesByCategoryView: View {
    @State private var showingPopover = false
    
    var category: String
    var activities: [Activity]
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                SearchBar(text: .constant(""))
                ScrollView(.vertical){
                    
                    ScrollView(.vertical) {
                        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], alignment: .leading, spacing: geometry.size.width*0.05, pinnedViews: [], content: {
                            
                            ForEach(activities.sorted(by: { $0.name < $1.name })){ activity in
                                VStack(alignment: .leading){
                                    ActivityImageView(name: activity.name).frame(width: geometry.size.width*0.275, height: geometry.size.height*0.275, alignment: . center)
                                    Text(activity.name)
                                        .font(.title3)
                                    Text("\(activity.stepsCount) steps")
                                        .foregroundColor(.gray)
                                }
                            }
                        })
                    }
                    .padding()
                                                            
                    Spacer()
                }
                
            }
            .navigationTitle("\(category)")
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                    Button(action: {
                        showingPopover = true
                    }, label: {
                        Text("Create activity")
                    })
                }
                
            }
            .sheet(isPresented: $showingPopover){
                NewActivity(showingPopover: $showingPopover)
            }
        }
    }
}