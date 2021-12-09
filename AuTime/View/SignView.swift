//
//  SignView.swift
//  AuTime
//
//  Created by Victor Vieira on 18/11/21.
//

import SwiftUI

struct SignView: View {
    
    @State var showSignIn = false
    @State var showSignUp = true
    @State var showForgotPassword = false
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Image("signback")
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                VStack{
                    Spacer(minLength: geometry.size.height * 0.065)
                    HStack{
                        Spacer(minLength: geometry.size.width * 0.5475)
                        if showSignIn {
                            SignInView(showThisView: $showSignIn, showSignUpView: $showSignUp, showPasswordView: $showForgotPassword)
                                .frame(width: geometry.size.width * 0.39, height: geometry.size.height * 0.83, alignment: .center)
                                .cornerRadius(22)
                        }
                        if showSignUp {
                            SignUpView(showThisView: $showSignUp, showSignInView: $showSignIn)
                                .frame(width: geometry.size.width * 0.39, height: geometry.size.height * 0.83, alignment: .center)
                                .cornerRadius(22)
                        }
                        if showForgotPassword {
                            ForgotPasswordView(showThisView: $showForgotPassword, showSignInView: $showSignIn)
                                .cornerRadius(22)
                        }
                            
                        Spacer(minLength: geometry.size.width * 0.0625)
                        
                    }
                    Spacer(minLength: geometry.size.height * 0.105)
                }
            }
        }
    }
}

struct SignView_Previews: PreviewProvider {
    static var previews: some View {
        SignView()
    }
}
