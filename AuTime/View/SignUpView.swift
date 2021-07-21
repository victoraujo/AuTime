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
    var body: some View {
        VStack{
            Text("SignUp")
                .fontWeight(.bold)
                .font(.title)
            Text(Auth.auth().currentUser?.email ?? "")
            Spacer()
            Text("email")
            TextField("Digite aqui", text: $email)
            Text("senha")
            SecureField("Digite aqui", text: $senha)
            Spacer()
            Text(error)
                .foregroundColor(.red)
            Button(action: {
                userVM.signIn(email: email, password: senha, handler: {(result, error) in
                    if let error = error {
                        self.error = error.localizedDescription
                        print(error.localizedDescription)
                    } else{
                        self.error = ""
                        print("Signed In!")}
                    
                })
            }, label: {
                Text("Create")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                
            })
        }
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
