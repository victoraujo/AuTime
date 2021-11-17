//
//  ChangeProfileView.swift
//  AuTime
//
//  Created by Matheus Andrade on 17/11/21.
//

import SwiftUI

struct ChangeProfileView: View {
    
    @ObservedObject var env: AppEnvironment
    
    @State var message: String = ""
    @State var showPassword: Bool = false
    @State var passwordText: String = ""
    @State var errorMessage: String = ""
        
    init(env: ObservedObject<AppEnvironment>) {
        self._env = env
        
        let childMessage = "Enter password to get access for parent control."
        let parentMessage = "Are you sure you want to switch to \(self.env.childName)'s profile?"
        self.message = self.env.profile == .child ? childMessage : parentMessage
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack (alignment: .center) {
                    Spacer()
                    
                    Text("Change Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black100Color)
                        .multilineTextAlignment(.leading)
                        .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    Text("\(message)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black100Color)
                        .multilineTextAlignment(.leading)
                        .frame(width: geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding([.horizontal, .bottom])
                    
                    // Textfield for password
                    if env.profile == .child {
                        VStack {
                            HStack(alignment: .center) {
                                if showPassword {
                                    TextField("Password", text: $passwordText)
                                        .cornerRadius(10)
                                } else {
                                    SecureField("Password", text: $passwordText)
                                        .cornerRadius(10)
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
                        
                    }
                    
                    Spacer()
                                                            
                    VStack(alignment: .center){
                        Button(action: {
                            if env.profile == .child {
                                if passwordText == env.parentControlPassword {
                                    env.isShowingChangeProfile = false
                                    env.changeProfile()
                                } else {
                                    errorMessage = "Wrong password! Try again."
                                }
                            } else {
                                env.isShowingChangeProfile = false
                                errorMessage = ""
                                env.changeProfile()
                            }
                            
                        }, label: {
                            Text("Change Profile")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 0.3*geometry.size.width, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .background(env.childColorTheme)
                                .cornerRadius(21)
                        })
                        .padding()
                        
                        Button(action: {
                            env.isShowingChangeProfile = false
                            errorMessage = ""
                        }, label: {
                            Text("Cancel")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(env.childColorTheme)
                            
                        })
                        .padding()
                    }
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
