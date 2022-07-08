//
//  SignInView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import AuthenticationServices
import FirebaseAnalytics
import FirebaseAuth
import GoogleSignIn
import SwiftUI

struct SignInView: View {
    
//    @EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
//    @State var coordinator: SignInWithAppleCoordinator?
    @State var hasTappedSignIn = false
    @State var alertItem: AlertItem?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(gradient: Gradient(colors: [Colors.foodiBrown, Colors.foodiYellow]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .edgesIgnoringSafeArea(.all)
//                .cornerRadius(15)
            
            GeometryReader { geometry in
                VStack {
                customNavigationBar
                    Spacer()
                    appleSignInButton
                        .padding(.bottom, 5)
                    googleSignInButton
                        .padding(.vertical, 5)
                    SignInWithFacebook
                        .padding(.vertical, 5)
                }
//                .padding(16)
//                .frame(width: geometry.size.width, height: geometry.size.height)
            }
//            .keyboardAdaptive()
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
    private var customNavigationBar: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
            }
            
            titleLabel
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image("chevron.left")
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
        }
    }
    
    private var titleLabel: some View {
        Text("FOODiii")
            .foregroundColor(Colors.green)
            .modifier(FontModifier(size: 20, weight: .extraBold))
    }
    
    private var appleSignInButton: some View {
        Button(action: {
            signInWithApple()
        }) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.26), radius: 12, x: 0, y: 0)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    Text("Sign in with Apple")
                        .foregroundColor(Colors.greyDark)
                        .modifier(FontModifier(size: 15, weight: .extraBold))
                )
        }
    }
    
    private var googleSignInButton: some View {
        Button(action: {
//            GIDSignIn.sharedInstance.
//            GIDSignIn.sharedInstance.presentingViewController = UIApplication.shared.windows.first?.rootViewController
//            GIDSignIn.sharedInstance.signIn()
        }) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.26), radius: 12, x: 0, y: 0)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    Text("Sign in with Google")
                        .foregroundColor(Colors.greyDark)
                        .modifier(FontModifier(size: 15, weight: .extraBold))
                )
        }
    }
    
    private var orDivider: some View {
        HStack {
            customDivider
                .foregroundColor(Colors.greyMedium)
            
            Text("or")
                .foregroundColor(Colors.greyMedium)
                .modifier(FontModifier(size: 15, weight: .regular))
            
            customDivider
                .foregroundColor(Colors.greyMedium)
        }
    }
    
    private func signInWithApple() {
//        coordinator = SignInWithAppleCoordinator(session: session)
//        if let coordinator = coordinator {
//            coordinator.startSignInWithAppleFlow()
//        }
    }
    
    private var customDivider: some View {
        RoundedRectangle(cornerRadius: 1)
            .frame(height: 2)
    }
    
    private var SignInWithFacebook: some View {
        Button(action: {
            
        }) {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.26), radius: 12, x: 0, y: 0)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .overlay(
                    Text("Sign in with Facebook")
                        .foregroundColor(Colors.greyDark)
                        .modifier(FontModifier(size: 15, weight: .extraBold))
                )
        }
    }
}

struct SignInPreview: PreviewProvider {
    static var previews: some View {
        SignInView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
