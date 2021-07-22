//
//  SignUpView.swift
//  AuTime
//
//  Created by Victor Vieira on 21/07/21.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @ObservedObject var userVM = UserViewModel()
    @State var email = ""
    @State var senha = ""
    @State var error = ""
    @State var showContentView = true
    
    init() {
        userVM.listen()
    }
    
    var body: some View {
        VStack{
            Text("SignUp")
                .fontWeight(.bold)
                .font(.title)
            
            Text((userVM.session?.email) ?? "Sem login")
                .fullScreenCover(isPresented: $showContentView) {
                    ContentView(show: $showContentView)
                }
            
            
            Spacer()
            Text("email")
            TextField("Digite aqui", text: $email)
            Text("senha")
            SecureField("Digite aqui", text: $senha)
            Spacer()
            Text(error)
                .foregroundColor(.red)
            
            HStack{
                Button(action: {
                    userVM.signUp(email: email, password: senha)
                }, label: {
                    Text("Create")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                    
                })
                
                Button(action: {
                    userVM.signIn(email: email, password: senha)
                }, label: {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                    
                })
                
                Button(action: {
                    userVM.signOut()
                }, label: {
                    Text("Logout")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                })
                
            }
        }
        .onChange(of: userVM.session?.email, perform: { email in
            if email != nil {
                showContentView = true
            } else {
                showContentView = false
            }
            
        })
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
