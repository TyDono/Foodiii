//
//  SignInView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import SwiftUI

//struct SignInView: View {
//    var body: some View {
//        Text("Sign In")
//    }
//}
//
//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}

var body: some View {
    ZStack(alignment: .bottom) {
        LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.cyan]), startPoint: .bottomLeading, endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
        
        GeometryReader { geometry in
            VStack {
//                customNavigationBar
//
//                Spacer()
////                    facebookSignInButton
////                        .padding(.bottom, 5)
//                appleSignInButton
//                    .padding(.bottom, 5)
//                googleSignInButton
//                    .padding(.vertical, 5)
//                orDivider
//                emailTextField
//                    .padding(.vertical, 5)
//                passwordTextField
//                    .padding(.vertical, 5)
//                forgotPasswordButton
//                    .padding(.vertical, 5)
//                signInButton
//                    .padding(.top, 5)
            }
            .padding(16)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .keyboardAdaptive()
    }
    .hideNavigationBar()
    .onAppear {
//        Analytics.logEvent(AnalyticsEventScreenView,
//                           parameters: [AnalyticsParameterScreenName: AnalyticsScreenNames.signInView])
    }
//    .alert(item: $alertItem) { alertItem in
//        Alert(title: alertItem.title,
//              message: alertItem.message,
//              dismissButton: alertItem.dismissButton)
//    }
}
