
//
//  WelcomeView.swift
//  NLogger
//
//  Created by Mavis II on 9/26/20.
//  Copyright © 2020 Bala. All rights reserved.
//

import SwiftUI


public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

struct WelcomeView: View {
    
    @EnvironmentObject var userauth: UserAuth
    @State var signUpIsPresent: Bool = false
    @State var signInIsPresent: Bool = false
    @State var selection: Int? = nil
    @State var viewState = CGSize.zero
    @State var MainviewState =  CGSize.zero
    @Environment(\.colorScheme) var colorScheme
    @State private var showButtons = true
    
    
    var body: some View {
        
        
        
        
        VStack {
            
            
            
            
            Spacer()
            
            
            
            if userauth.user == nil || !userauth.isEmailverified 
                
            {
                   
                VStack(spacing:20) {
                    
                
                    if showButtons{
                    VStack(spacing: 20){
                        
                        Button(action: {self.signUpIsPresent = true}){
                            Text("SIGN UP").padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(0)
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.init(.systemYellow))).sheet(isPresented: self.$signUpIsPresent){
                            
                            SignUpView().environmentObject(self.userauth)
                            
                        }
                        
                        
                        Button(action: {
                            self.signInIsPresent = true
                            
                        }){
                            
                            Text("SIGN IN").padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            
                        }
                            
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(0)
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(Color.init(.systemYellow)))
                        .sheet(isPresented: $signInIsPresent) {
                            
                            SignInView(onDismiss:{
                                
                                print("Dismissed")
                                
                            }).environmentObject(self.userauth)
                            
                        }
                        
                        
                    }.animation(.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 2))
                    .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
              
                    
                    }
                    
                    
                }
                .padding(10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                
            }
                
                
                
                
                
            else{
        
                
                actIndSignin(shouldAnimate: .constant(true))
                
            }
            
            
            Spacer()
            
            
            
        }
        .edgesIgnoringSafeArea(.top).edgesIgnoringSafeArea(.bottom)
        
        
    }
    
    
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(UserAuth())
        
    }
}
