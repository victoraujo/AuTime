//
//  ActivitiesLibraryView.swift
//  AuTime
//
//  Created by Victor Vieira on 03/11/21.
//

import SwiftUI

struct ActivitiesLibraryView: View {
    @ObservedObject var activitiesVM = ActivityViewModel()
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject var imageManager = ImageViewModel()
    @ObservedObject var env: AppEnvironment
    @State private var showingPopover = false
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                SearchBar(text: .constant(""))
                ScrollView(.vertical, showsIndicators: false){
                    HStack{
                        Text("Todas Atividades")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding([.top,.leading])
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(activitiesVM.activities.sorted(by: { $0.name.uppercased() < $1.name.uppercased() })){ activity in
                                VStack(alignment: .leading){
                                    ActivityImageView(name: activity.name).frame(width: geometry.size.width*0.3, height: geometry.size.height*0.3, alignment: . center)
                                    Text(activity.category)
                                        .foregroundColor(.gray)
                                    Text(activity.name)
                                        .font(.title3)
                                    Text("\(activity.stepsCount) passos")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                        }                        
                    }.padding(.bottom)
                    
                    ForEach(env.categories, id: \.self){ category in
                        HStack{
                            Text("\(category)")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding([.top,.leading])
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(activitiesVM.activities.filter{ $0.category.elementsEqual(category)}){ activity in
                                    VStack(alignment: .leading){
                                        ActivityImageView(name: activity.name).frame(width: geometry.size.width*0.2, height: geometry.size.height*0.2, alignment: . center)
                                        Text(activity.name)
                                            .font(.title3)
                                        Text("\(activity.stepsCount) passos")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                            }
                        }.padding(.bottom)
                    }
                    
                    Spacer()
                }
                
            }
            .navigationTitle("Biblioteca de Atividades")
            .toolbar {
                
                ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                    Button(action: {
                        showingPopover = true
                        //                        ActivityViewModel.shared.createActivity(category: "Teste", completions: [Completion(date: Date(), feedback: "Opa")], star: false, name: "Testinho 2", days: [1,2,3,4,5,6,7], steps: 2, time: Date(), handler: {})
                    }, label: {
                        Text("Criar Atividade")
                    })
                }
                
            }
            .sheet(isPresented: $showingPopover){
                NewActivity(env: env, showingPopover: $showingPopover)
            }
        }
    }
}
