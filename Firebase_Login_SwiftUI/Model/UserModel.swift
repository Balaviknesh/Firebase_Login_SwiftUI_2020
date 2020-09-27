//
//  UserModel.swift
//  Firebase_Login_SwiftUI
//
//  Created by Mavis II on 9/26/20.
//  Copyright © 2020 Bala. All rights reserved.
//

import Foundation

class User {
    
    var uid: String
    var email: String?
    var emailVerified: Bool
    var userName: String?
    var userAlertInfo: String?
    
    
    init(uid: String, email: String?, emailVerified: Bool, userName: String?,  userAlertInfo: String?) {
        self.uid = uid
        self.email = email
        self.emailVerified = emailVerified
        self.userName = userName
        self.userAlertInfo = userAlertInfo
    }
}
