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
    @ObservedObject var session = FirebaseManager()
    @State var email = ""
    @State var senha = ""
    @State var error = ""
    @State var showContentView = true
    
    init(){
        session.listen()
    }
    var body: some View {
        VStack{
            Text("SignUp")
                .fontWeight(.bold)
                .font(.title)
            if session.session?.email != nil{
                Text((session.session?.email)!)
                .fullScreenCover(isPresented: $showContentView) {
                    ContentView()
                }
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
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
