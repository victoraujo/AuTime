//
//  SignUpView.swift
//  AuTime
//
//  Created by Victor Vieira on 21/07/21.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 4)
    @State var email = ""
    @State var password = ""
    @State var parentName = ""
    @State var childName = ""
    @State var error = ""
    @State var showAlert = false
    @State private var showInvalidAlert = false
    @State private var showRegisterAlert = false
    @Binding var showThisView: Bool
    @Binding var showSignInView: Bool
    init(showThisView: Binding<Bool>, showSignInView: Binding<Bool>){
        self._showThisView = showThisView
        self._showSignInView = showSignInView
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer(minLength: geometry.size.height * 0.092)
                HStack(alignment: .center){
                    Spacer(minLength: geometry.size.width * 0.081)
                    Group{
                        VStack(alignment: .leading){
                            Image("autime")
                            Text("Bem-vindo\nao AuTime")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding([.top, .trailing])
                            Text("Faça seu cadastro para começar")
                                .foregroundColor(.black74Color)
                            TextField("Nome do Responsável", text: $parentName, onEditingChanged: { if $0 { self.kGuardian.showField = 0 } })
                            //                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(.black06Color)
                                .padding()
                                .font(Font.system(size: 17, weight: .medium, design: .rounded))
                                .background(RoundedRectangle(cornerRadius: 9))
                                .foregroundColor(.black76Color)
                                .background(GeometryGetter(rect: $kGuardian.rects[0]))
                            //                                    .background(Color.black74Color)
                                .padding(.top)
                            TextField("Nome da Criança", text: $childName, onEditingChanged: { if $0 { self.kGuardian.showField = 1 } })
                                .foregroundColor(.black06Color)
                                .padding()
                                .font(Font.system(size: 17, weight: .medium, design: .rounded))
                                .background(RoundedRectangle(cornerRadius: 9))
                                .foregroundColor(.black76Color)
                                .background(GeometryGetter(rect: $kGuardian.rects[1]))
                            TextField("Email", text: $email, onEditingChanged: { if $0 { self.kGuardian.showField = 2 } })
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .foregroundColor(.black06Color)
                                .padding()
                                .font(Font.system(size: 17, weight: .medium, design: .rounded))
                                .background(RoundedRectangle(cornerRadius: 9))
                                .foregroundColor(.black76Color)
                                .background(GeometryGetter(rect: $kGuardian.rects[2]))
                            SecureField("Senha", text: $password)
                                .foregroundColor(.black06Color)
                                .padding()
                                .font(Font.system(size: 17, weight: .medium, design: .rounded))
                                .background(RoundedRectangle(cornerRadius: 9))
                                .foregroundColor(.black76Color)
                                .padding(.bottom)
                                .background(GeometryGetter(rect: $kGuardian.rects[3]))
                                .onTapGesture(perform: {self.kGuardian.showField = 3})
                            HStack(alignment: .center){
                                //Spacer()
                                Button(action: {
                                    if(email != "" && password != "" && parentName != "" && childName != ""){
                                        userManager.signUp(email: email, password: password, parentName: parentName, childName: childName) {erro in
                                            if let _ = erro {
                                                showInvalidAlert = true
                                            } else {
                                                showRegisterAlert = true
                                            }
                                        }
                                    }
                                    else{
                                        showInvalidAlert = true
                                    }
                                    showAlert = true
                                }, label: {
                                    Text("Cadastrar")
                                        .font(Font.system(size:20, design: .rounded))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: geometry.size.width * 0.838)
                                        
                                        
                                })
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue100Color)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                //Spacer()
                            }
                            HStack{
                                Spacer()
                                Text("Já possui cadastro?")
                                    .foregroundColor(.black90Color)
                                    .padding(.top)
                                Spacer()}
                            HStack{
                                Spacer()
                                Button(action: {
                                    showSignInView = true
                                    showThisView = false
                                }, label: {
                                    Text("Fazer Login")
                                        .foregroundColor(.blue)
                                })
                                Spacer()
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.838, height: geometry.size.height * 0.85, alignment: .leading)
                    .offset(y: kGuardian.slide)
                    Spacer(minLength: geometry.size.width * 0.081)
                }.onAppear { self.kGuardian.addObserver() }
                .onDisappear { self.kGuardian.removeObserver() }
                Spacer(minLength: geometry.size.height * 0.058)
            }
        }.background(Color.white)
            .alert(isPresented: $showAlert) {
                if(showRegisterAlert){
                    return Alert(title: Text("Cadastro realizado!"), message: Text("Enviamos um email para \"\(email)\", confirme para fazer login."), dismissButton: .default(Text("Fazer Login"), action: {
                        showAlert = false
                        showRegisterAlert = false
                        showInvalidAlert = false
                        showSignInView = true
                        showThisView = false
                    }))
                } else {
                    return Alert(title: Text("Cadastro inválido!"), message: Text("Email e/ou senha incorretos"), dismissButton: .default(Text("Voltar"), action: {
                        showAlert = false
                        showRegisterAlert = false
                        showInvalidAlert = false
                    }))
                }
            }
    }
}
