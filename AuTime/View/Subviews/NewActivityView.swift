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
    
    @State var showAlert = false
    @State var alertType: AlertType = .none
    
    @Binding var showingPopover: Bool
    let alertMessage = String(describing: Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription")!) + " Vá em Configurações e libere o acesso de AuTime a sua Galeria de Fotos."
    
    @State private var isShowingActivityPhotoPicker = false
    @State private var activityImage: UIImage = UIImage(named: "PlaceholderImage.png") ?? UIImage()
    @State private var selectedCategory: String = ""
    @State private var activityName: String = ""
    @State private var activityStar: Bool = false
    
    @State private var isCreatingSubActivity: Bool = false
    
    @State private var isShowingSubactivityPhotoPicker = false
    @State private var subActivityImage: UIImage = UIImage(named: "PlaceholderImage.png") ?? UIImage()
    @State private var subActivityName: String = ""
    @State private var listSubactivities: [ListSubActivity] = []
    @State private var isListEditable: Bool = false
    
    func checkSubActivityFields() -> Bool {            
        if subActivityName == "" {
            return false
        }
        
        if subActivityImage == UIImage(named: "PlaceholderImage.png") ?? UIImage() {
            return false
        }
        
        return true
    }
    
    func checkActivityFields() -> Bool {
        if activityName == "" {
            return false
        }
        
        if selectedCategory == "" {
            return false
        }
        
        if activityImage == UIImage(named: "PlaceholderImage.png") ?? UIImage() {
            return false
        }
            
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
                                            showAlert = false
                                        }
                                        else {
                                            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                                
                                                // TO DO: Separate access for limited and authorized
                                                if status == .limited || status == .authorized {
                                                    isShowingActivityPhotoPicker = true
                                                    showAlert = false
                                                }
                                                else {
                                                    isShowingActivityPhotoPicker = false
                                                    alertType = .accessPhotosDenied
                                                    showAlert = true
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
                                        NavigationLink(destination: {
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
                                                                        showAlert = false
                                                                    }
                                                                    else {
                                                                        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                                                            
                                                                            // TO DO: Separate access for limited and authorized
                                                                            if status == .limited || status == .authorized {
                                                                                isShowingSubactivityPhotoPicker = true
                                                                                showAlert = false
                                                                            }
                                                                            else {
                                                                                isShowingSubactivityPhotoPicker = false
                                                                                alertType = .accessPhotosDenied
                                                                                showAlert = true
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
                                                        .onAppear {
                                                            subActivityName = subactivity.name
                                                        }
                                                    }
                                                }
                                            }
                                            .onAppear {
                                                subActivityImage = subactivity.image
                                                subActivityName = subactivity.name
                                            }
                                            .onDisappear {
                                                self.subActivityName = ""
                                                self.subActivityImage = UIImage(named: "PlaceholderImage.png") ?? UIImage()
                                            }
                                            .toolbar {
                                                ToolbarItem(placement: ToolbarItemPlacement.principal) {
                                                    Text("Editar Subatividade")
                                                        .font(.title2)
                                                        .bold()
                                                }
                                                
                                                ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                                                    Button(action: {
                                                        if checkSubActivityFields() {
                                                            if let index = self.listSubactivities.firstIndex(where: {$0.name == subactivity.name}) {
                                                                listSubactivities[index] = ListSubActivity(name: subActivityName, order: index, image: subActivityImage)
                                                            }
                                                                                                                        
                                                            self.isCreatingSubActivity = false
                                                        } else {
                                                            alertType = .emptyField
                                                            showAlert = true
                                                        }
                                                    }, label: {
                                                        Text("Salvar")
                                                            .bold()
                                                    })
                                                }
                                            }
                                        }, label: {
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
                                        })
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
                                                            showAlert = false
                                                        }
                                                        else {
                                                            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                                                
                                                                // TO DO: Separate access for limited and authorized
                                                                if status == .limited || status == .authorized {
                                                                    isShowingSubactivityPhotoPicker = true
                                                                    showAlert = false
                                                                }
                                                                else {
                                                                    isShowingSubactivityPhotoPicker = false
                                                                    alertType = .accessPhotosDenied
                                                                    showAlert = true
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
                                            if checkSubActivityFields() {
                                                let count = listSubactivities.count
                                                self.listSubactivities.append(ListSubActivity(name: subActivityName, order: count, image: subActivityImage))
                                                self.isCreatingSubActivity = false
                                            } else {
                                                alertType = .emptyField
                                                showAlert = true
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
                            if checkActivityFields() {
                                ActivityViewModel.shared.createActivity(category: selectedCategory, completions: [], star: activityStar, name: activityName, days: [], steps: listSubactivities.count, time: Date(), image: activityImage) {
                                    ActivityViewModel.shared.fetchData()
                                    if let activity = ActivityViewModel.shared.activities.first(where: {$0.name == activityName}), let id = activity.id {
                                        for i in 0...listSubactivities.count-1 {
                                            let sub = listSubactivities[i]
                                            let subManager = SubActivityViewModel()
                                            subManager.activityReference = id
                                            subManager.createSubActivity(name: sub.name, order: i, image: sub.image) {}
                                        }
                                    }
                                 
                                    return nil
                                }
                                
                                showingPopover = false
                            } else {
                                alertType = .emptyField
                                showAlert = true
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
                .alert(isPresented: $showAlert) {
                    if alertType == .emptyField {
                        return Alert(title: Text("Campos Vazios"), message: Text("Você deve preencher todos os campos e adicionar uma foto para criar uma nova atividade ou subatividade."), dismissButton: .default(Text("OK")))
                    } else if alertType == .accessPhotosDenied {
                        return Alert(title: Text("AuTime deseja acessar as suas fotos"), message: Text(self.alertMessage), primaryButton: .default(Text("Cancelar")), secondaryButton: .default(Text("Abrir Configurações"), action: {
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
                    
                    return Alert(title: Text(""))
                }                                
            }
        }
    }
}
