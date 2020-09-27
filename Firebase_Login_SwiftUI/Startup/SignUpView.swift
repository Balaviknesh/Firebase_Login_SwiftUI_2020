
//
//  SignUpView.swift
//  NLogger
//
//  Created by Mavis II on 9/26/20.
//  Copyright © 2020 Bala. All rights reserved.
//

import SwiftUI
import Firebase

struct actIndSignup: UIViewRepresentable {
    
    @Binding var shouldAnimate: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: Context) {
        if self.shouldAnimate {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}



struct SignUpView: View {
    
    @EnvironmentObject var userauth: UserAuth
    @Environment(\.presentationMode) var presentationMode
    @State var emailAddress: String = ""
    @State var password: String = ""
    @State var agreeCheck: Bool = false
    @State var errorText: String = ""
    @State private var showAlert = false
    @State private var shouldAnimate = false
    @Environment(\.colorScheme) var colorScheme
    @State private var showError = false
    
    @State private var showButton = false
    
    
    
    var alert: Alert {
        
        Alert(title: Text("Verify your Email ID"), message: Text("Please click the link in the verification email sent to you"), dismissButton: .default(Text("Dismiss")){
            
            self.presentationMode.wrappedValue.dismiss()
            self.emailAddress = ""
            self.password = ""
            self.agreeCheck = false
            self.errorText = ""
            
            })
    }
    
    
    var body: some View {
        
        
        VStack {
            
            TitleView(Title: "SIGN UP").onAppear {
                self.showButton.toggle()
            }
            
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
                
                SecureField("Password", text: $password)
                
                Toggle(isOn: $agreeCheck)
                {
                    Text("Agree to the Terms and Conditions and Privacy Policy of NLogger").font(.caption)
                    
                }.padding(.vertical, 10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
                if self.showButton{
                
                Button(action: {
                    
                    self.hideKeyboard()
                    
                    if (!self.emailAddress.isEmpty && !self.password.isEmpty)
                    {
                        
                        if(self.agreeCheck){
                            
                            self.shouldAnimate = true
                            self.signUp()
                        }
                        else{
                            
                            self.errorText = "Please Agree to the Terms and Conditions and Privacy Policy of NLogger"
                            self.showError = true
                        }
                        
                    }
                    
                    else{
                        
                        if(self.emailAddress.isEmpty){
                            
                            self.errorText = "E-Mail address cannot be empty"
                            self.showError = true
                            
                        }
                        
                        
                        if(self.password.isEmpty){
                            
                            self.errorText = "Password cannot be empty"
                            self.showError = true
                            
                        }
                        
                        if(self.password.isEmpty && self.emailAddress.isEmpty)
                        {
                            
                            self.errorText = "E-Mail address cannot be empty"
                            self.showError = true
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                }) {
                    
                    Text("SIGN UP").padding(10)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
                }
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .cornerRadius(0)
                    .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.init(.systemYellow)))
                .animation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 2))
                      .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                    
                
                }
                
                actIndSignup(shouldAnimate: self.$shouldAnimate)
                
                Spacer()
                
            }.padding(10)
            
        }
            
        .edgesIgnoringSafeArea(.top).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            
            
        .alert(isPresented: $showAlert, content: { self.alert })
        
    }
    
    
    func signUp() {
        
        self.shouldAnimate = true
        userauth.signUp(email: self.emailAddress, password: self.password) { (result, error) in
            
            if let error = error
            {
                self.errorText = error.localizedDescription
                self.showError = true
                self.shouldAnimate = false
                return
            }
                
            else{
               
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    if let error = error {
                        self.errorText = error.localizedDescription
                        self.showError = true
                        return
                    }
                    
                    self.showAlert.toggle()
                    
                    self.shouldAnimate = false
                    
                }
                
                
                
                
            }
            
            
            
            
            
            
        }
        
        
    }
    
    
    
    
}

struct SignUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignUpView().environment(\.colorScheme, .light)
    }
    
    
}
