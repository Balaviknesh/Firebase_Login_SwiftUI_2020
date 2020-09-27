//
//  Settings.swift
//  NLogger
//
//  Created by Mavis II on 6/22/20.
//  Copyright © 2020 Bala. All rights reserved.
//

import SwiftUI
import Firebase

struct Settings: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userauth: UserAuth
    
    
    
    @State private var changeUserName = false
    @State private var signOutAlert = false
    @State private var deleteAccountAlert = false
    @State private var username: String = ""
    @State private var showButton = false
    
    var body: some View {
        
        NavigationView{
            
            
            
            VStack(){
                
                TitleView(Title: "SETTINGS").zIndex(2)
                
                VStack{
                    
                    ScrollView{
                        
                        Group{
                            
                            VStack(alignment: .leading, spacing: 10){
                                
                                Text("User Name")
                                
                                Text( self.username).foregroundColor(.secondary).onAppear {
                                    
                                    self.username = self.userauth.userName
                                }
                                
                                Text("Email")
                                
                                Text( self.userauth.user?.email ?? "Unable to get Email").foregroundColor(.secondary)
                                
                                
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                            
                            VStack{
                                
                                Button(action:{
                                    
                                    self.changeUserName = true
                                    
                                }){
                                    
                                    HStack{
                                        Image(systemName: "pencil.tip.crop.circle")
                                        Text("Change Username")
                                        
                                    }.padding(10)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .cornerRadius(0)
                                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                                            .stroke(lineWidth: 2.0)
                                            .foregroundColor(.yellow))
                                    
                                }.sheet(isPresented:  $changeUserName) {
                                    ChangeUserName(userName: self.$username).environmentObject(self.userauth)
                                }
                                
                            }
                            
                        }.padding()
                        
                    }.zIndex(1).onAppear(perform: {
                        self.showButton = true
                    }).onDisappear(perform: {
                        
                        withAnimation {
                            self.showButton = false
                            
                        }
                        
                        
                    })
                    
                    Spacer()
                    
                    if self.showButton {
                        
                        Group{
                            
                            
                            Button(action: {
                                
                                self.signOutAlert = true
                                
                                
                            }) {
                                
                                HStack{
                                    Image(systemName: "escape").foregroundColor(Color.red)
                                    Text("Sign Out")
                                    
                                }
                                .padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color.init(red: 0.035, green: 0, blue: 0.435))
                                .cornerRadius(10).shadow(radius: 5)
                                
                                
                                
                            }.alert(isPresented: $signOutAlert) {
                                
                                Alert(title: Text("Alert"), message: Text("Do you really want to Sign out?"),
                                      
                                      primaryButton: .default(Text("Yes"), action: {
                                        
                                        
                                        _ = Auth.auth().currentUser
                                        
                                        print("Sign out executed")
                                        
                                        _ = self.userauth.signOut()
                                        
                                        self.userauth.userWarnInfo = "You are now signed out"
                                        
                                        self.userauth.user = nil

                                      }),
                                      secondaryButton: .default(Text("No")))
                                
                            }
                            
                            Button(action: {
                                self.deleteAccountAlert = true
                            }) {
                                
                                HStack{
                                    Image(systemName: "trash").foregroundColor(Color.red)
                                    Text("Delete Account")
                                } .padding(10)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.white)
                                    .background(Color.init(red: 0.035, green: 0, blue: 0.435))
                                    .cornerRadius(10).shadow(radius: 5)
                                
                                
                            }.alert(isPresented: $deleteAccountAlert) {
                                
                                Alert(title: Text("Alert"), message: Text("Do you really want delete your account? All your account informations will be erased and cant be undone."),
                                      
                                      primaryButton: .default(Text("Yes"), action: {
                                        
                                        
                                        
                                        let user = Auth.auth().currentUser
                                        
                                        print("Settings: Executing User Deletion")
                                        
                                        user?.delete { error in
                                            if error != nil {
                                                print("Settings: User Delete Error: ", error as Any)
                                                self.userauth.userWarnInfo = String(error!.localizedDescription)
                                                
                                                return
                                            }
                                            
                                            print("Settings: User data added to deletion")
                                            print("Settings: Account Deleted")
                                            
                                            self.userauth.user = nil
                                            self.userauth.userWarnInfo = "Account is deleted"
                                            
                                            return
                                            
                                        }
                                        
                                      }),
                                      secondaryButton: .default(Text("No")))
                                
                                
                            }
                            
                            
                            
                        }.padding(.horizontal).animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1))
                            .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                        
                    }
                    
                    
                }.padding(.bottom, 10)
                
                
            }
                
                
                
            .edgesIgnoringSafeArea(.top)
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
}





struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        
        Settings()
        
    }
}

struct ChangeUserName: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userauth: UserAuth
    
    @Binding var userName: String
    
    
    
    var body: some View {
        
        
        VStack(spacing: 10){
            
            
            
            Text("New Username").frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                .padding(10)
            
            
            TextField("something good", text: $userName).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                .padding(10)
            
            
            Button(action:{
                
                
                if(self.userName.count < 20 && self.userName.count > 0)
                {
                    
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.userName
                    changeRequest?.commitChanges { (error) in
                        if((error) != nil){
                            print("Settings: ", error!)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        else{
                            self.userauth.userName = self.userName
                            print("Settings: Username change Success")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }else{
                    
                    self.userName = "Not Set"
                    
                }
                
                
                
            }){
                
                Text("Change")
                    .padding(10)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .cornerRadius(0)
                    .overlay(RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .foregroundColor(.yellow))
                
                
            }
            
            
            Button("Cancel"){
                
                self.presentationMode.wrappedValue.dismiss()
                
            } .padding(10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .cornerRadius(0)
                .overlay(RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2.0)
                    .foregroundColor(.yellow))
            
            
            
            
            Spacer()
            
            
        }.padding(10)
        
        
    }
}


