//
//  LoadingAppLogInView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/8/22.
//

import SwiftUI

struct NavigationLogInView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        NavigationView {
            if !userAuth.isLoggedIn {
                SignInView()
            } else {
                HomeView()
            }
        }
        
    }
}

struct LoadingAppLogInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLogInView()
    }
}
