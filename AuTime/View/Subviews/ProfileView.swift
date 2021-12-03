//
//  ChangeProfileSheet.swift
//  AuTime
//
//  Created by Matheus Andrade on 26/11/21.
//

import SwiftUI
import Photos

struct ProfileView: View {
    @ObservedObject var env: AppEnvironment
    @ObservedObject var profileManager: ProfileViewModel = ProfileViewModel.shared
    @ObservedObject var userManager: UserViewModel = UserViewModel.shared
    @ObservedObject var parentImageManager: ImageViewModel = ImageViewModel()
    @ObservedObject var childImageManager: ImageViewModel = ImageViewModel()
    
    @State var parentPhoto: UIImage = UIImage()
    @State var childPhoto: UIImage = UIImage()
    @State var pickerPhoto: UIImage = UIImage()
    @State var photoToPicker: String = ""
    
    @State var parentName: String = ""
    @State var childName: String = ""
    @State var parentEmail: String = ""
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    
    let alertMessage = String(describing: Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription")!) + " Abra as Configurações e permita ao AuTime acessar suas fotos."
    
    enum AlertType {
        case none
        case emptyField
        case deleteAccount
        case confirmDeleteAccount
        case accessPhotosDenied
    }
    
    @State var showAlert: Bool = false
    @State var showConfirmDeleteAccount: Bool = false
    @State var showPhotoPicker: Bool = false
    @State var alertType: AlertType = .none
    
    
    func downloadImages() {
        if let email = userManager.session?.email {
            var parentImageName: String = String(profileManager.profileInfo.lastUpdateParentPhoto)
            parentImageName += "-parent.png"
            
            let parentPath = "users/\(email)/Profile/\(parentImageName)"
            self.parentImageManager.downloadImage(from: parentPath) {}
            
            var childImageName: String = String(profileManager.profileInfo.lastUpdateChildPhoto)
            childImageName += "-child.png"
            
            let childPath = "users/\(email)/Profile/\(childImageName)"
            self.childImageManager.downloadImage(from: childPath) {}
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                VStack{
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(uiImage: parentPhoto)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width*0.075, height: UIScreen.main.bounds.width*0.075, alignment: .center)
                                .clipShape(Circle())
                                .onTapGesture {
                                    let photos = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                                    
                                    // TO DO: Separate access for limited and authorized
                                    if photos == .limited || photos == .authorized {
                                        photoToPicker = "parent"
                                        showPhotoPicker = true
                                        showAlert = false
                                    }
                                    else {
                                        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                            
                                            // TO DO: Separate access for limited and authorized
                                            if status == .limited || status == .authorized {
                                                photoToPicker = "parent"
                                                showPhotoPicker = true
                                                showAlert = false
                                            }
                                            else {
                                                showPhotoPicker = false
                                                alertType = .accessPhotosDenied
                                                showAlert = true
                                            }
                                        })
                                    }
                                }
                            
                            Text("\(profileManager.getParentName())")
                                .font(.title3)
                                .bold()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Image(uiImage: childPhoto)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width*0.075, height: UIScreen.main.bounds.width*0.075, alignment: .center)
                                .clipShape(Circle())
                                .onTapGesture {
                                    let photos = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                                    
                                    // TO DO: Separate access for limited and authorized
                                    if photos == .limited || photos == .authorized {
                                        photoToPicker = "child"
                                        showPhotoPicker = true
                                        showAlert = false
                                    }
                                    else {
                                        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                                            
                                            // TO DO: Separate access for limited and authorized
                                            if status == .limited || status == .authorized {
                                                photoToPicker = "child"
                                                showPhotoPicker = true
                                                showAlert = false
                                            }
                                            else {
                                                showPhotoPicker = false
                                                alertType = .accessPhotosDenied
                                                showAlert = true
                                            }
                                        })
                                    }
                                }
                            
                            Text("\(profileManager.getChildName())")
                                .font(.title3)
                                .bold()
                        }
                        
                        Spacer()
                    }
                    
                    List {
                        Section{
                            NavigationLink(destination: {
                                VStack {
                                    Form {
                                        Section(header: Text("Nome do Responsável"), content: {
                                            TextField("Responsável", text: $parentName)
                                        })
                                        
                                        Section(header: Text("Nome da Criança"), content: {
                                            TextField("Criança", text: $childName)
                                        })
                                        
                                    }
                                }
                                .onDisappear {
                                    self.parentName = profileManager.getParentName()
                                    self.childName = profileManager.getChildName()
                                }
                                .toolbar(content: {
                                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                                        Text("Nomes")
                                            .bold()
                                    }
                                    
                                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                                        Button(action: {
                                            if childName != "" && parentName != "" {
                                                profileManager.updateProfile(parentName: parentName, childName: childName)
                                            } else {
                                                self.alertType = .emptyField
                                                showAlert = true
                                            }
                                        }, label: {
                                            Text("Salvar")
                                                .bold()
                                        })
                                    }
                                })
                            }, label: {
                                Text("Nomes")
                            })
                            
                            NavigationLink(destination: {
                                VStack {
                                    Form {
                                        Section(header: Text("Senhas"), content: {
                                            TextField("Senha Atual", text: $currentPassword)
                                            TextField("Nova Senha", text: $newPassword)
                                            TextField("Confirmar Senha", text: $confirmPassword)
                                        })
                                        
                                        HStack {
                                            
                                            Text("Esqueceu a Senha?")
                                                .foregroundColor(.blue)
                                                .onTapGesture(perform: {
                                                    // TO DO:
                                                    // LINK TO FORGOT PASSWORD PAGE!
                                                })
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                }
                                .onDisappear {
                                    self.currentPassword = ""
                                    self.newPassword = ""
                                    self.confirmPassword = ""
                                }
                                .toolbar(content: {
                                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                                        Text("Alterar Senha")
                                            .bold()
                                    }
                                    
                                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                                        Button(action: {
                                            if  currentPassword != "" && newPassword != "" && confirmPassword != "" {
                                                // TO DO
                                                // if currentPassword == SENHA {
                                                //  CHANGE PASSWORD
                                                // } else {
                                                //  show POP-UP for wrong password
                                                // }
                                            } else {
                                                self.alertType = .emptyField
                                                showAlert = true
                                            }
                                        }, label: {
                                            Text("Alterar")
                                                .bold()
                                        })
                                    }
                                })
                            }, label: {
                                Text("Senhas")
                            })
                        }
                        
                        Section {
                            Button(action: {
                                env.isShowingProfileSettings = false
                                userManager.signOut()
                            }, label: {
                                Text("Finalizar Sessão")
                                    .foregroundColor(.blue)
                            })
                        }
                        
                        Section {
                            Button(action: {
                                alertType = .deleteAccount
                                showAlert = true
                            }, label: {
                                Text("Excluir Cadastro")
                                    .foregroundColor(.red)
                            })
                        }
                    }
                    .frame(height: geometry.size.height*0.5, alignment: .center)
                    
                    Button(action: {
                        env.isShowingProfileSettings = false
                        env.changeProfile()
                    }, label: {
                        Text("Alterar Perfil")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 0.4*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .background(env.parentColorTheme)
                            .cornerRadius(21)
                    })
                    
                    Spacer()
                }
                .onChange(of: showAlert, perform: { _ in
                    print("CONFIRM: \(showConfirmDeleteAccount)")
                    
                    if showConfirmDeleteAccount {
                        showAlert = true
                    } else {
                        showConfirmDeleteAccount = false
                    }
                })
                .alert(isPresented: $showAlert) {
                    if alertType == .emptyField {
                        return Alert(title: Text("Campos Vazios"), message: Text("Você deve preencher todos os campos para poder alterar as suas informações pessoais."), dismissButton: .default(Text("OK")))
                    } else if alertType == .deleteAccount {
                        return Alert(title: Text("Deletar Cadastro"), message: Text("Você deseja excluir permanentemente o seu cadastro? Essa é uma ação definitiva!"), primaryButton: .cancel(Text("Cancelar")), secondaryButton: .destructive(Text("Excluir")) {
                            self.alertType = .confirmDeleteAccount
                            self.showConfirmDeleteAccount = true
                        })
                    } else if alertType == .confirmDeleteAccount {
                        return Alert(title: Text("Deletar Cadastro"), message: Text("Você precisa inserir sua senha para deleter permanentemente o seu cadastro."), primaryButton: .cancel(Text("Cancelar")), secondaryButton: .destructive(Text("Excluir")) {
                            // TO DO: USER MANAGER -> DELETE ACCOUNT
                        })
                    } else if alertType == .accessPhotosDenied {
                        return Alert(title: Text("AuTime Would deseja acessar as suas fotos"), message: Text(self.alertMessage), primaryButton: .default(Text("Cancelar")), secondaryButton: .default(Text("Abrir Configurações"), action: {
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
                .listStyle(.insetGrouped)
                .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
                .toolbar(content: {
                    ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                        Button(action: {
                            env.isShowingProfileSettings = false
                        }, label: {
                            Text("OK")
                                .bold()
                        })
                    }
                    
                    ToolbarItem(placement: ToolbarItemPlacement.principal) {
                        Text("Perfil")
                            .font(.title2)
                            .bold()
                    }
                })
            }
        }
        .accentColor(env.parentColorTheme)
        .sheet(isPresented: $showPhotoPicker, content: {
            PhotoPicker(activityImage: $pickerPhoto)
        })
        .onAppear {
            self.parentName = profileManager.getParentName()
            self.childName = profileManager.getChildName()
            if let email = userManager.session?.email {
                var childImageName: String = "\(profileManager.profileInfo.lastUpdateChildPhoto)"
                childImageName += "-child.png"
                let childPath = "users/\(email)/Profile/\(childImageName)"
                self.childImageManager.downloadImage(from: childPath, {
                    self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                })
                
                var parentImageName: String = "\(profileManager.profileInfo.lastUpdateParentPhoto)"
                parentImageName += "-parent.png"
                let parentPath = "users/\(email)/Profile/\(parentImageName)"
                self.parentImageManager.downloadImage(from: parentPath) {
                    self.parentPhoto = self.parentImageManager.imageView.image ?? UIImage()
                }
            }
            
        }
        .onChange(of: pickerPhoto, perform: { image in
            profileManager.updateProfilePhoto(photo: image, endpoint: photoToPicker) {
                if let email = userManager.session?.email {
                    var childImageName: String = "\(profileManager.profileInfo.lastUpdateChildPhoto)"
                    childImageName += "-child.png"
                    let childPath = "users/\(email)/Profile/\(childImageName)"
                    self.childImageManager.downloadImage(from: childPath) {
                        self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                    }
                    
                    var parentImageName: String = "\(profileManager.profileInfo.lastUpdateParentPhoto)"
                    parentImageName += "-parent.png"
                    let parentPath = "users/\(email)/Profile/\(parentImageName)"
                    self.parentImageManager.downloadImage(from: parentPath) {
                        self.parentPhoto = self.parentImageManager.imageView.image ?? UIImage()
                    }
                    
                    
                }
            }
        })
        .onChange(of: profileManager.profileInfo, perform: { profile in
            self.parentName = profileManager.getParentName()
            self.childName = profileManager.getChildName()
            
            if let email = userManager.session?.email {
                var childImageName: String = "\(profileManager.profileInfo.lastUpdateChildPhoto)"
                childImageName += "-child.png"
                let childPath = "users/\(email)/Profile/\(childImageName)"
                self.childImageManager.downloadImage(from: childPath) {
                    self.childPhoto = self.childImageManager.imageView.image ?? UIImage()
                }
                
                var parentImageName: String = "\(profileManager.profileInfo.lastUpdateParentPhoto)"
                parentImageName += "-parent.png"
                let parentPath = "users/\(email)/Profile/\(parentImageName)"
                self.parentImageManager.downloadImage(from: parentPath) {
                    self.parentPhoto = self.parentImageManager.imageView.image ?? UIImage()
                }
            }
        })
        .onChange(of: childImageManager.imageView.image, perform: { image in
            if let image = image {
                self.childPhoto = image
            }
        })
        .onChange(of: parentImageManager.imageView.image, perform: { image in
            if let image = image {
                self.parentPhoto = image
            }
        })
        .onDisappear {
            env.isShowingProfileSettings = false
        }
    }
}

