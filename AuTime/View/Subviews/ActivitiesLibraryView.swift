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
    @State var activities: [Activity] = []
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                SearchBar(text: .constant(""))
                
                HStack{
                    Text("Todas Atividades")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top,.leading])
                    Spacer()
                }
                
                ScrollView(.vertical, showsIndicators: false){
                    if activities.count == 0 {
                        HStack {
                            Spacer()
                            VStack (alignment: .center){
                                Text("Nenhuma Atividade")
                                    .font(.title2)
                                    .bold()
                                    .padding()
                                
                                Text("Você ainda não adicionou nenhuma atividade a sua biblioteca.")
                                    .font(.subheadline)
                                    .foregroundColor(.black90Color)
                                
                            }
                            .frame(alignment: .center)
                            
                            Spacer()
                        }
                        .frame(idealWidth: geometry.size.width, minHeight: geometry.size.height*0.2)
                    } else {
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
                    }
                    
                    ForEach(env.categories, id: \.self){ category in
                        HStack{
                            Text("\(category)")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding([.top,.leading])
                            Spacer()
                        }
                        let filtered = activitiesVM.activities.filter{ $0.category.elementsEqual(category)}
                        
                        if filtered.count == 0 {
                            HStack {
                                Spacer()
                                VStack (alignment: .center){
                                    Text("Nenhuma Atividade")
                                        .font(.title2)
                                        .bold()
                                        .padding()
                                    
                                    Text("Você ainda não adicionou nenhuma atividade a esta categoria.")
                                        .font(.subheadline)
                                        .foregroundColor(.black90Color)
                                    
                                }
                                .frame(alignment: .center)
                                
                                Spacer()
                            }
                            .frame(idealWidth: geometry.size.width, minHeight: geometry.size.height*0.2)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack{
                                    ForEach(filtered){ activity in
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
                            }
                        }
                    }
                    .padding(.bottom)
                    
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
        .onAppear {
            self.activities = self.activitiesVM.activities
        }
        .onChange(of: self.activitiesVM.activities, perform: { activities in
            self.activities = activities
        })
    }
}
