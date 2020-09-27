//
//  FirebaseAuth.swift
//  Firebase_Login_SwiftUI
//
//  Created by Mavis II on 9/26/20.
//  Copyright © 2020 Bala. All rights reserved.
//

import Foundation

import SwiftUI
import Firebase


class UserAuth: ObservableObject {
    
    
    @Published var user: User?
    @Published var isEmailverified: Bool = false
    var isSignIn = false
    @Published var userName: String = ""
    @Published var deviceActive: Bool = false
    @Published var userWarnInfo: String = ""
   
 

    
    
    init() {
        
        print("Auth: Initialized")
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user {
                
                self.user = User(
                    
                    uid: user.uid,
                    email: user.email,
                    emailVerified: user.isEmailVerified,
                    userName: user.displayName,
                    userAlertInfo: ""
                    
                )
                
                print("Auth: Signed In: ", self.user?.uid ?? "UID nil after signed in - Problem")
                
                self.userName = user.displayName ?? "Not Set"
                
                self.isEmailverified = user.isEmailVerified
                

            }
                
            else {
                
                self.isSignIn = true
                print("Auth: Signed Out: ", self.user?.uid ?? " User Signed Out")
                self.user = nil
              
                
            }
            
        }
        
    }

    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        
    }
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.user = nil
            return true
        } catch {
            return false
        }
    }
    
    
}


