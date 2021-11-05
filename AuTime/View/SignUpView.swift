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
    @ObservedObject var env: AppEnvironment
    @State var email = ""
    @State var senha = ""
    @State var error = ""
    
    var body: some View {
        VStack{
//            Text("SignUp")
//                .fontWeight(.bold)
//                .font(.title)
//            
//            Text((userManager.session?.email) ?? "Sem login")
//            
//            Spacer()
//            Text("email")
//            TextField("Digite aqui", text: $email)
//            Text("senha")
//            SecureField("Digite aqui", text: $senha)
//            Spacer()
//            Text(error)
//                .foregroundColor(.red)
//            
//            HStack{
//                Button(action: {
//                    userManager.signUp(email: email, password: senha)
//                }, label: {
//                    Text("Create")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                    
//                })
//                
//                Button(action: {
//                    userManager.signIn(email: email, password: senha)
//                }, label: {
//                    Text("Login")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                    
//                })
//                
//                Button(action: {
//                    userManager.signOut()
//                }, label: {
//                    Text("Logout")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                })
//                
//            }
        }
        .onAppear() {
            // Automatic login in the test account
            userManager.signIn(email: "matheus3@eu.com", password: "matheus123")
        }
        
    }
}
