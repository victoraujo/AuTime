//
//  ChangeProfileSheet.swift
//  AuTime
//
//  Created by Matheus Andrade on 26/11/21.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var env: AppEnvironment
    @ObservedObject var profileManager: ProfileViewModel = ProfileViewModel.shared
    @ObservedObject var userManager: UserViewModel = UserViewModel.shared
        
    @State var parentName: String = ""
    @State var childName: String = ""
    @State var parentEmail: String = ""
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    
    @State var showEmptyFieldAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                VStack{
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(uiImage: env.parentPhoto)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width*0.075, height: UIScreen.main.bounds.width*0.075, alignment: .center)
                                .clipShape(Circle())
                            
                            Text("\(profileManager.getParentName())")
                                .font(.title3)
                                .bold()
                        }
                        
                        Spacer()
                        
                        VStack {
                            Image(uiImage: env.childPhoto)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width*0.075, height: UIScreen.main.bounds.width*0.075, alignment: .center)
                                .clipShape(Circle())
                            
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
                                                //userManager.updateProfile(parentName: parentName, childName: childName)
                                                profileManager.updateProfile(parentName: parentName, childName: childName)
                                            } else {
                                                self.showEmptyFieldAlert = true
                                            }
                                        }, label: {
                                            Text("Salvar")
                                                .bold()
                                        })
                                        .alert(isPresented: $showEmptyFieldAlert) { () -> Alert in
                                            Alert(title: Text("Campos Vazios"), message: Text("Você deve preencher todos os campos para poder alterar as suas informações pessoais."), dismissButton: .default(Text("OK")))
                                        }
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
                                                // if currentPassword == SENHA {
                                                //  CHANGE PASSWORD
                                                // } else {
                                                //  show POP-UP for wrong password
                                                // }
                                            } else {
                                                self.showEmptyFieldAlert = true
                                            }
                                        }, label: {
                                            Text("Alterar")
                                                .bold()
                                        })
                                        .alert(isPresented: $showEmptyFieldAlert) { () -> Alert in
                                            Alert(title: Text("Campos Vazios"), message: Text("Você deve preencher todos os campos para poder alterar as suas informações pessoais."), dismissButton: .default(Text("OK")))
                                        }
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
                                env.isShowingProfileSettings = false
                                userManager.signOut()
                            }, label: {
                                Text("Excluir Conta")
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
        .onAppear {
            self.parentName = profileManager.getParentName()
            self.childName = profileManager.getChildName()
        }
        .onChange(of: profileManager.profileInfo, perform: { profile in
            self.parentName = profileManager.getParentName()
            self.childName = profileManager.getChildName()
        })
        .onDisappear {
            env.isShowingProfileSettings = false
        }
    }
}

