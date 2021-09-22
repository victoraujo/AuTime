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
    @State var email = ""
    @State var senha = ""
    @State var error = ""
    @State var showChildView = false
    @State var showParentView = false
    
    init() {
        showChildView = userManager.isLogged()
    }
    
    var body: some View {
        VStack{
            Text("SignUp")
                .fontWeight(.bold)
                .font(.title)
            
            Text((userManager.session?.email) ?? "Sem login")
            
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
                    userManager.signUp(email: email, password: senha)
                }, label: {
                    Text("Create")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                    
                })
                
                Button(action: {
                    userManager.signIn(email: email, password: senha)
                }, label: {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                    
                })
                
                Button(action: {
                    userManager.signOut()
                }, label: {
                    Text("Logout")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                })
                
            }
        }
        .fullScreenCover(isPresented: $showChildView) {
            ChildView(showChildView: $showChildView, showParentView: $showParentView)
        }
        .fullScreenCover(isPresented: $showParentView) {
            ParentView(showChildView: $showChildView, showParentView: $showParentView)
        }
        
        .onChange(of: userManager.session?.email, perform: { email in
            if email != nil {
                showChildView = true
                print("show child: \(showChildView)")
            } else {
                showChildView = false
                print("show child: \(showChildView)")
            }
            
        })
        
    }
}
