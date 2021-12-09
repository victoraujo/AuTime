//
//  SignInView.swift
//  AuTime
//
//  Created by Victor Vieira on 24/11/21.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var userManager = UserViewModel.shared
    @State var email = ""
    @State var password = ""
    @State var parentName = ""
    @State var childName = ""
    @State var error = ""
    @State var logado = true
    @State var showAlert = false
    @State private var showInvalidAlert = false
    @State private var showConfirmAlert = false
    @Binding var showThisView: Bool
    @Binding var showSignUpView: Bool
    @Binding var showPasswordView: Bool

    init(showThisView: Binding<Bool>, showSignUpView: Binding<Bool>, showPasswordView: Binding<Bool>){
        self._showThisView = showThisView
        self._showSignUpView = showSignUpView
        self._showPasswordView = showPasswordView
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
                            Text("Faça seu login para começar")
                                .foregroundColor(.black74Color)
                                .padding(.bottom)
                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .foregroundColor(.black06Color)
                                .padding()
                                .font(Font.system(size: 17, weight: .medium, design: .rounded))
                                .background(RoundedRectangle(cornerRadius: 9))
                                .foregroundColor(.black76Color)
                                .padding(.top)
                            SecureField("Senha", text: $password)
                                .foregroundColor(.black06Color)
                                .padding()
                                .font(Font.system(size: 17, weight: .medium, design: .rounded))
                                .background(RoundedRectangle(cornerRadius: 9))
                                .foregroundColor(.black76Color)
                                .padding(.bottom)
                            HStack{
                                Spacer()
                                Button(action: {
                                    showPasswordView = true
                                    showThisView = false
                                }, label: {
                                    Text("Esqueceu a senha?")
                                        .foregroundColor(.blue)
                                })
                            }
                            
                            Spacer()
                            HStack(alignment: .center){
                                Button(action: {
                                    userManager.signIn(email: email, password: password){
                                        if !userManager.isVerified(){
                                            userManager.signOut()
                                            showConfirmAlert = true
                                            showAlert = true
                                        }
                                    }
                                }, label: {
                                    Text("Entrar")
                                        .font(Font.system(size:20, design: .rounded))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: geometry.size.width * 0.838)
                                    
                                    
                                })
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue100Color)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            HStack{
                                Spacer()
                                Text("Não possui cadastro?")
                                    .foregroundColor(.black90Color)
                                    .padding(.top)
                                Spacer()}
                            HStack{
                                Spacer()
                                Button(action: {
                                    showSignUpView = true
                                    showThisView = false
                                }, label: {
                                    Text("Fazer Cadastro")
                                        .foregroundColor(.blue)
                                })
                                Spacer()
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.838, height: geometry.size.height * 0.85, alignment: .leading)
                    Spacer(minLength: geometry.size.width * 0.081)
                }
                Spacer(minLength: geometry.size.height * 0.058)
            }
        }.background(Color.white)
            .alert(isPresented: $showAlert) {
                if(showConfirmAlert){
                    return Alert(title: Text("Email inválido!"), message: Text("Você ainda não confirmou seu email"), dismissButton: .default(Text("Voltar"), action: {
                        showAlert = false
                        showConfirmAlert = false
                        showInvalidAlert = false
                    }))
                } else {
                    return Alert(title: Text("Login inválido!"), message: Text("Email e/ou senha incorretos"), dismissButton: .default(Text("Voltar"), action: {
                        showAlert = false
                        showConfirmAlert = false
                        showInvalidAlert = false
                    }))
                }
            }
    }
}
