//
//  Projects.swift
//  NLogger
//
//  Created by Mavis II on 6/22/20.
//  Copyright © 2020 Bala. All rights reserved.
//

import SwiftUI

struct Projects: View {
    
  
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userAuth: UserAuth
    @State private var showButton = false
    
    
    var body: some View {
        
        
        NavigationView {
            
            VStack(){
                
                TitleView(Title: "HOME") .onAppear(perform: {
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.showButton = true
                    }
                    
                })
                
                VStack(){
                    
                    
                    Text("Projects").font(.largeTitle)
                    
                    
                }.padding([.leading, .top], 10).frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                
                    
                    Text("No projects").font(.subheadline).padding()

                
                Spacer()
                
            }  .edgesIgnoringSafeArea(.top)
            
        
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
        
        
    }
    
    
    
}

struct Projects_Previews: PreviewProvider {
    static var previews: some View {
        Projects()
    }
}

