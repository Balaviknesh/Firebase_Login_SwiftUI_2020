//
//  HideKeyboard.swift
//  Firebase_Login_SwiftUI
//
//  Created by Mavis II on 9/26/20.
//  Copyright © 2020 Bala. All rights reserved.
//


import SwiftUI


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

