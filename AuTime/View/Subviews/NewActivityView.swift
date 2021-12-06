//
//  NewActivityView.swift
//  AuTime
//
//  Created by Matheus Andrade on 19/11/21.
//

import SwiftUI
import Photos

struct NewActivity: View {
    @ObservedObject var env: AppEnvironment
    
    @State var isShowingAccessDeniedAlert = false
    @Binding var showingPopover: Bool
    let alertMessage = String(describing: Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription")!) + " Vá em Configurações e libere o acesso de AuTime a sua Galeria de Fotos."
    
    @State private var isShowingActivityPhotoPicker = false
    @State private var activityImage: UIImage = UIImage(named: "PlaceholderImage.png") ?? UIImage()
    @State private var selectedCategory: String = "Nenhuma"
    @State private var activityName: String = ""
    @State private var activityStar: Bool = false
    
    @State private var isCreatingSubActivity: Bool = false
    
    @State private var isShowingSubactivityPhotoPicker = false
    @State private var subActivityImage: UIImage = UIImage(named: "PlaceholderImage.png") ?? UIImage()
    @State private var subActivityName: String = ""
    @State private var listSubactivities: [ListSubActivity] = []
    @State private var isListEditable: Bool = false
    
    func checkFields() -> Bool{
        return true
    }
    
    var body: some View{
        NavigationView {
            GeometryReader{ geometry in
                VStack{
                    Form {
                        Section{
                            HStack{
                                Spacer()
                                Image(uiImage: activityImage)
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.3)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(21)
                                    .padding()
                                    .onTapGesture {
                                        let photos = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                                        
                                        // TO DO: Separate access for limited and authorized
                                        if photos == .limited || photos == .authorized {
                                            isShowingActivityPhotoPicker = true
                                            isShowingAccessDeniedAlert = false
                                        }
                                        else {
                                            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                                
                                                // TO DO: Separate access for limited and authorized
                                                if status == .limited || status == .authorized {
                                                    isShowingActivityPhotoPicker = true
                                                    isShowingAccessDeniedAlert = false
                                                }
                                                else {
                                                    isShowingActivityPhotoPicker = false
                                                    isShowingAccessDeniedAlert = true
                                                }
                                            })
                                        }
                                    }
                                Spacer()
                            }
                        }
                        
                        TextField("Título da Atividade", text: $activityName)
                            .padding()
                            .cornerRadius(8)
                        
                        Section {
                            
                            Picker("Categoria", selection: $selectedCategory) {
                                ForEach(env.categories, id: \.self) {
                                    Text($0)
                                }
                                .toolbar {
                                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                                        Text("Categorias")
                                            .font(.title2)
                                            .bold()
                                    }
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                            
                            Toggle("Gerar Estrela", isOn: $activityStar)
                        }
                        
                        Section(content: {
                            if listSubactivities.count == 0 {
                                HStack {
                                    Spacer()
                                    VStack (alignment: .center){
                                        Text("Nenhuma Subatividade")
                                            .font(.title)
                                            .bold()
                                        
                                        Text("Você ainda não adicionou nenhuma subatividade a esta atividade.")
                                            .font(.subheadline)
                                            .foregroundColor(.black90Color)
                                        
                                    }
                                    .frame(alignment: .center)
                                    
                                    Spacer()
                                }.frame(height: geometry.size.height*0.3, alignment: .center)
                                
                            } else {
                                List {
                                    ForEach(listSubactivities, id: \.self) { subactivity in
//                                        NavigationLink(destination: {
//                                            VStack {
//                                                Text("OIIII")
//                                            }
//                                        }, label: {
                                            HStack (alignment: .center){
                                                Image(uiImage: subactivity.image)
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .aspectRatio(contentMode: .fill)
                                                    .cornerRadius(5)
                                                    .padding(.vertical)
                                                
                                                Text(subactivity.name)
                                                    .font(.title3)
                                                    .padding()
                                            }
                                        //})
                                    }
                                    .onDelete { (indexSet) in
                                        self.listSubactivities.remove(atOffsets: indexSet)
                                    }
                                    .onMove(perform: {source, destination in
                                        listSubactivities.move(fromOffsets: source, toOffset: destination)
                                    })
                                }
                                .environment(\.editMode, .constant(.active))
                                
                            }
                            
                            
                            NavigationLink(isActive: $isCreatingSubActivity, destination: {
                                VStack {
                                    Form {
                                        Section {
                                            HStack{
                                                Spacer()
                                                Image(uiImage: subActivityImage)
                                                    .resizable()
                                                    .frame(width: geometry.size.width * 0.45, height: geometry.size.height * 0.3)
                                                    .aspectRatio(contentMode: .fill)
                                                    .cornerRadius(21)
                                                    .padding()
                                                    .onTapGesture {
                                                        let photos = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                                                        
                                                        // TO DO: Separate access for limited and authorized
                                                        if photos == .limited || photos == .authorized {
                                                            isShowingSubactivityPhotoPicker = true
                                                            isShowingAccessDeniedAlert = false
                                                        }
                                                        else {
                                                            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                                                
                                                                // TO DO: Separate access for limited and authorized
                                                                if status == .limited || status == .authorized {
                                                                    isShowingSubactivityPhotoPicker = true
                                                                    isShowingAccessDeniedAlert = false
                                                                }
                                                                else {
                                                                    isShowingSubactivityPhotoPicker = false
                                                                    isShowingAccessDeniedAlert = true
                                                                }
                                                            })
                                                        }
                                                    }
                                                Spacer()
                                            }
                                            
                                            Section {
                                                TextField("Título da Subatividade", text: $subActivityName)
                                                    .padding()
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                                .onDisappear {
                                    self.subActivityName = ""
                                    self.subActivityImage = UIImage(named: "PlaceholderImage.png") ?? UIImage()
                                }
                                .toolbar {
                                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                                        Text("Criar Subatividade")
                                            .font(.title2)
                                            .bold()
                                    }
                                    
                                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                                        Button(action: {
                                            if checkFields() {
                                                let count = listSubactivities.count
                                                self.listSubactivities.append(ListSubActivity(name: subActivityName, order: count, image: subActivityImage))
                                                self.isCreatingSubActivity = false
                                            } else {
                                                print("Campos vazios")
                                            }
                                        }, label: {
                                            Text("Adicionar")
                                                .bold()
                                        })
                                    }
                                }
                                
                            }, label: {
                                HStack {
                                    Text("Adicionar Subatividade")
                                        .foregroundColor(.blue)
                                    Spacer()
                                }
                            })
                            
                        }, header: {
                            Text("SUBATIVIDADES")
                        })
                    }
                    Spacer()
                }
                .listStyle(.insetGrouped)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.cancellationAction) {
                        Button(action: {
                            showingPopover = false
                        }, label: {
                            Text("Cancelar")
                        })
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                        Text("Nova Atividade")
                            .font(.title2)
                            .bold()
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                        Button(action: {
                            if checkFields() {
                                ActivityViewModel.shared.createActivity(category: selectedCategory, completions: [], star: activityStar, name: activityName, days: [], steps: 0, time: Date(), image: activityImage, handler: {
                                    ActivityViewModel.shared.fetchData()
                                })
                                
                                showingPopover = false
                            } else {
                                print("Campos vazios")
                            }
                        }, label: {
                            Text("Adicionar")
                                .bold()
                        })
                    }
                }
                .sheet(isPresented: $isShowingActivityPhotoPicker, content: {
                    PhotoPicker(activityImage: $activityImage)
                })
                .sheet(isPresented: $isShowingSubactivityPhotoPicker, content: {
                    PhotoPicker(activityImage: $subActivityImage)
                })
                .alert(isPresented: $isShowingAccessDeniedAlert) { () -> Alert in
                    Alert(title: Text("AuTime gostaria de ter acesso a suas fotos"), message: Text(self.alertMessage), primaryButton: .default(Text("Cancelar")), secondaryButton: .default(Text("Ir para configurações"), action: {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)")
                            })
                        }
                        
                    }))
                }
            }
        }
    }
}
