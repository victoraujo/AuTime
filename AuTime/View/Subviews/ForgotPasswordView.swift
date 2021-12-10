//
//  forgotPasswordView.swift
//  AuTime
//
//  Created by Victor Vieira on 06/12/21.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var userManager = UserViewModel.shared
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    @State var email = ""
    @State var error = ""
    @State var showAlert = false
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
                            Text("Esqueci minha\nsenha")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding([.top, .trailing, .bottom])
                            Text("Preencha o email que você usou para cadastro")
                                .foregroundColor(.black74Color)
                                .padding(.top)
                            Spacer()
                            TextField("Email", text: $email, onEditingChanged: { if $0 { self.kGuardian.showField = 0 } })
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .foregroundColor(.black06Color)
                                .padding()
                                .font(Font.system(size: 17, weight: .medium, design: .rounded))
                                .background(RoundedRectangle(cornerRadius: 9))
                                .foregroundColor(.black76Color)
                                .padding(.bottom)
                                .background(GeometryGetter(rect: $kGuardian.rects[0]))
              
                            HStack(alignment: .center){
                                Button(action: {
                                    if (email != "") {
                                        showAlert = true
                                        userManager.resetPassword(email: email)
                                    }
                                }, label: {
                                    Text("Recuperar Senha")
                                        .font(Font.system(size:20, design: .rounded))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: geometry.size.width * 0.838)
                                    
                                    
                                })
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue100Color)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action: {
                                    showSignInView = true
                                    showThisView = false
                                }, label: {
                                    Text("Login")
                                        .foregroundColor(.blue)
                                })
                                Spacer()
                            }
                        }
                    }
                    .offset(y: kGuardian.slide)
                    .frame(width: geometry.size.width * 0.838, height: geometry.size.height * 0.85, alignment: .leading)
                    Spacer(minLength: geometry.size.width * 0.081)
                }
                Spacer(minLength: geometry.size.height * 0.058)
            }
            .onAppear { self.kGuardian.addObserver() }
            .onDisappear { self.kGuardian.removeObserver() }
        }.background(Color.white)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Tudo certo!"), message: Text("Enviamos um email para\"\(email)\" com sua nova senha"), dismissButton: .default(Text("Fazer login"), action: {
                    showAlert = false
                    showSignInView = true
                    showThisView = false
                }))
            }
    }
}
