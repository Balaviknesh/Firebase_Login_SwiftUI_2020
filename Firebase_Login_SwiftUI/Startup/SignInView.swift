//
//  SignInView.swift
//  NLogger
//
//  Created by Mavis II on 9/26/20.
//  Copyright © 2020 Bala. All rights reserved.
//
//

import SwiftUI
import Firebase


struct actIndSignin: UIViewRepresentable {
    @Binding var shouldAnimate: Bool
    
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        
        uiView.color = .systemYellow
        
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

struct SignInView: View {
    
    @EnvironmentObject var userauth: UserAuth
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State private var shouldAnimate = false
    @State var emailAddress: String = ""
    @State var password: String = ""
    @State var verifyEmail: Bool = true
    @State private var showEmailAlert = false
    @State private var showPasswordAlert = false
    @State var errorText: String = ""
    @State var token: String = ""
    @State var showError: Bool = false
    
    @State var showButton: Bool = false
    
    
    var onDismiss: () -> ()
    
    var verifyEmailAlert: Alert {
        
        Alert(title: Text("Verify your E-mail ID"), message: Text("Please click the link in the verification email sent to you"), dismissButton: .default(Text("Dismiss")){
            
            self.presentationMode.wrappedValue.dismiss()
            self.emailAddress = ""
            self.verifyEmail = true
            self.password = ""
            self.errorText = ""
            
            })
    }
    
    var passwordResetAlert: Alert {
        
        Alert(title: Text("Reset your password"), message: Text("Please click the link in the password reset email sent to you"), dismissButton: .default(Text("Dismiss")){
            
            self.emailAddress = ""
            self.verifyEmail = true
            self.password = ""
            self.errorText = ""
            
            })
    }
    
    var body: some View {
        
        VStack {
            
            TitleView(Title: "SIGN IN").onAppear(perform:{
                
                self.showButton.toggle()
                
            })
            
            VStack(spacing: 10) {
                
                if self.showError{
                    
                    HStack{
                        
                        Text(self.errorText).font(.footnote).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading).foregroundColor(.red)
                        
                    }.padding(10)
                        .animation(.easeInOut)
                        .transition(AnyTransition.move(edge: .leading
                        ).combined(with: .opacity))
                        .onTapGesture {
                            withAnimation {
                                self.showError = false
                            }
                            
                    }.onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.showError = false
                            }
                        }
                    })
                    
                    
                }
                
                Text("E-Mail").font(.title).fontWeight(.thin).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
                TextField("user@domain.com", text: $emailAddress).textContentType(.emailAddress)
                
                Text("Password").font(.title).fontWeight(.thin)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
                
                SecureField("Password", text: $password).padding(.bottom, 10)
                
                
                
                if showButton {
                    VStack(spacing: 20){
                        
                        Button(action: {
                            
                            self.hideKeyboard()
                            
                            
                            
                            if (!self.emailAddress.isEmpty && !self.password.isEmpty)
                            {
                                
                                
                                self.shouldAnimate = true
                                self.signIn()
                                
                                
                                
                            }
                                
                            else{
                                
                                if(self.emailAddress.isEmpty){
                                    self.showError  = true
                                    
                                    self.errorText = "E-Mail address cannot be empty"
                                    
                                }
                                
                                
                                if(self.password.isEmpty){
                                    
                                    self.showError  = true
                                    
                                    self.errorText = "Password cannot be empty"
                                    
                                }
                                
                                if(self.password.isEmpty && self.emailAddress.isEmpty)
                                {
                                    self.showError  = true
                                    
                                    self.errorText = "E-Mail address cannot be empty"
                                }
                                
                                
                            }
                            
                            
                        })
                        {
                            
                            Text("SIGN IN").padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(0)
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.init(.systemYellow)))
                        
                        
                        Button(action: {
                            
                            self.hideKeyboard()
                            
                            Auth.auth().sendPasswordReset(withEmail: self.emailAddress) { error in
                                
                                if let error = error {
                                    self.showError  = true
                                    self.errorText = error.localizedDescription
                                    return
                                }
                                
                                self.showPasswordAlert.toggle()
                                
                            }
                            
                            
                        }
                        ) {
                            Text("FORGOT PASSWORD").padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(0)
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.init(.systemYellow)))
                        
                    }.animation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 2))
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    
                }
                
                actIndSignin(shouldAnimate: self.$shouldAnimate)
                
                
                
                if (!verifyEmail) {
                    
                    Button(action: {
                        
                        self.hideKeyboard()
                        
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
                            if let error = error {
                                self.errorText = error.localizedDescription
                                self.showError  = true
                                return
                            }
                            self.showEmailAlert.toggle()
                            
                        }
                    }) {
                        
                        Text("RESEND VERIFY E-MAIL").padding(10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        
                        
                    }
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .cornerRadius(0)
                    .overlay(RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(Color.init(.systemYellow)))
                    
                    
                }

            }.padding(10)
            
            
            
        }.edgesIgnoringSafeArea(.top).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            
            .alert(isPresented: $showEmailAlert, content: { self.verifyEmailAlert })
            
            .alert(isPresented: $showPasswordAlert, content: { self.passwordResetAlert })
        
        
    }
    
    func signIn() {
        
        self.shouldAnimate = true
        userauth.signIn(email: self.emailAddress, password: self.password) { (result, error) in
            
            if let error = error
            {   print("Sign In: UID:  Failed")
                self.errorText = error.localizedDescription
                self.showError  = true
                self.shouldAnimate = false
                
                return
            }
            print("Sign In: UID:  Success")
            
            self.verifyEmail = result!.user.isEmailVerified
            self.userauth.isEmailverified = self.verifyEmail
            if(!self.verifyEmail)
            {   print("Sign In: EMailVerification :  Failed")
                self.errorText = "Please verify your E-Mail"
                self.showError  = true
                self.shouldAnimate = false
                
                return
            }
            print("Sign In: EMailVerification :  Success")
                                  
                      
        
        }
    }


}

struct SignInView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        
        SignInView(onDismiss: {print("hi")}).environmentObject(UserAuth())
        
    }
}


