//
//  Home.swift
//  NLogger
//
//  Created by Mavis II on 6/22/20.
//  Copyright © 2020 Bala. All rights reserved.
//

import SwiftUI
import Firebase

struct Home: View {
    
    @EnvironmentObject var userauth: UserAuth
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0
    @State private var showAlert: Bool = false

    
    
    init(){
        
        UISwitch.appearance().onTintColor = UIColor.systemYellow
        UITextField.appearance().tintColor = UIColor.systemYellow
        UITableView.appearance().separatorStyle = .none
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemYellow
        
    }
    
    var alert: Alert {
        Alert(title: Text("Alert"), message: Text(userauth.userWarnInfo), dismissButton: .default(Text("Dismiss")))
        
    }

    var body: some View {
        
        VStack{

            if (userauth.user != nil && userauth.isEmailverified) {

                    TabView {

                        Projects().tabItem {
                            Image(systemName: "house")
                            Text("Projects")}.tag(0)


                        Settings().tabItem {
                            Image(systemName: "gear")
                            Text("Settings")}.tag(1)



                    }
                    .accentColor(colorScheme == .dark ? Color.init(UIColor.systemYellow) : Color.init(red: 0.035, green: 0, blue: 0.435))

            }
                
            else{
                
                WelcomeView().environmentObject(self.userauth)
                
            }
            
            
        }
    
    }
    
    
    
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(UserAuth())
    }
}
