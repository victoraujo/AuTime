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
    @State var isShowingPhotoPicker = false
    @State var isShowingAccessDeniedAlert = false
    @Binding var showingPopover: Bool
    let alertMessage = String(describing: Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription")!) + " Vá em Configurações e libere o acesso de AuTime a sua Galeria de Fotos."
    
    @State private var activityImage: UIImage = UIImage(named: "Breakfast") ?? UIImage()
    @State private var selectedCategory: String = "Nenhuma"
    @State private var activityName: String = ""
    @State private var activityStar: Bool = false
    
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
                                            isShowingPhotoPicker = true
                                            isShowingAccessDeniedAlert = false
                                        }
                                        else {
                                            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                                
                                                // TO DO: Separate access for limited and authorized
                                                if status == .limited || status == .authorized {
                                                    isShowingPhotoPicker = true
                                                    isShowingAccessDeniedAlert = false
                                                }
                                                else {
                                                    isShowingPhotoPicker = false
                                                    isShowingAccessDeniedAlert = true
                                                }
                                            })
                                        }
                                    }
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            isShowingPhotoPicker = true
                        }
                        
                        TextField("Título da Atividade", text: $activityName)
                            .padding()
                            .cornerRadius(8)
                        
                        Section {
                            
                            Picker("Categoria", selection: $selectedCategory) {
                                ForEach(env.categories, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                            Toggle("Gerar Estrela", isOn: $activityStar)
                        }
                        
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
                .sheet(isPresented: $isShowingPhotoPicker, content: {
                    PhotoPicker(activityImage: $activityImage)
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
