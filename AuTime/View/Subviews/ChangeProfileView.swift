//
//  ChangeProfileView.swift
//  AuTime
//
//  Created by Matheus Andrade on 17/11/21.
//

import SwiftUI

struct ChangeProfileView: View {
    
    @ObservedObject var env: AppEnvironment
    @State var showPassword: Bool = false
    @State var passwordText: String = ""
    @State var errorMessage: String = ""
        
    var childMessage = "Insira a senha para acessar a Página do Responsável"
    var parentMessage = "Você tem certeza que deseja ir para a Página de \(self.env.childName)?"
    
    init(env: ObservedObject<AppEnvironment>) {
        self._env = env
        
        childMessage = "Insira a senha para acessar a Página do Responsável"
        parentMessage = "Você tem certeza que deseja ir para a Página de \(self.env.childName)?"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack (alignment: .center) {
                    Spacer()
                    
                    Text("Trocar Perfil")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black100Color)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    Text("\(self.env.profile == .child ? childMessage : parentMessage)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black90Color)
                        .multilineTextAlignment(.leading)
                        .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding([.horizontal, .bottom])
                    
                    // Textfield for password
                    if env.profile == .child {
                        VStack {
                            HStack(alignment: .center) {
                                if showPassword {
                                    TextField("  Senha", text: $passwordText)
                                        .frame(width: 0.6*geometry.size.width, height: 40, alignment: .center)
                                        .border(env.childColorTheme)
                                        .cornerRadius(5)
                                        .padding()
                                    
                                } else {
                                    SecureField("  Senha", text: $passwordText)
                                        .frame(width: 0.6*geometry.size.width, height: 40, alignment: .center)
                                        .border(env.childColorTheme)
                                        .cornerRadius(5)
                                        .padding()
                                }
                                
                                Image(systemName: showPassword ? "eye" : "eye.slash")
                                    .foregroundColor(env.childColorTheme)
                                    .onTapGesture {
                                        showPassword.toggle()
                                    }
                            }
                            
                            Text("\(errorMessage)")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding()
                        
                    }
                                                                                
                    VStack(alignment: .center){
                        Button(action: {
                            if env.profile == .child {
                                if passwordText == env.parentControlPassword {
                                    env.isShowingChangeProfile = false
                                    env.changeProfile()
                                } else {
                                    errorMessage = "Senha incorreta! Tente novamente"
                                }
                            } else {
                                env.isShowingChangeProfile = false
                                errorMessage = ""
                                env.changeProfile()
                            }
                            
                        }, label: {
                            Text("Trocar Perfil")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 0.4*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .background(env.profile == .child ? env.childColorTheme : env.parentColorTheme)
                                .cornerRadius(21)
                        })
                        .padding()
                        
                        Button(action: {
                            env.isShowingChangeProfile = false
                            passwordText = ""
                            errorMessage = ""
                        }, label: {
                            Text("Cancelar")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(env.profile == .child ? env.childColorTheme : env.parentColorTheme)
                            
                        })
                        .padding()
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                }
                .background(Rectangle().fill(Color.white).cornerRadius(21).shadow(color: .black90Color, radius: 5, x: 0, y: 6))
                .onDisappear {
                    errorMessage = ""
                    passwordText = ""
                    showPassword = false
                }
            }
            
        }
    }
}
