//
//  SignInView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import CryptoKit
import Firebase
import FirebaseAuth
import SwiftUI
import AuthenticationServices
import GoogleSignIn

struct SignInView: View {
    
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
//    @State var coordinator: SignInWithAppleCoordinator?
    @State var currentNonce: String?
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
                    SignInWithAppleButton(
                        onRequest: { request in
                            let nonce = randomNonceString()
                            currentNonce = nonce
                            
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = sha256(nonce)
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                switch authResults.credential {
                                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                    
                                    guard let nonce = currentNonce else {
                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                    }
                                    guard let appleIDToken = appleIDCredential.identityToken else {
                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                    }
                                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                        return
                                    }
                                    
                                    let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                                    Auth.auth().signIn(with: credential) { (authResult, error) in
                                        if (error != nil) {
                                            // Error. If error.code == .MissingOrInvalidNonce, make sure
                                            // you're sending the SHA256-hashed nonce as a hex string with
                                            // your request to Apple.
                                            print(error?.localizedDescription as Any)
                                            return
                                        }
                                        print("signed in")
            //                            self.userAuth.login()
                                    }
                                    
                                    print("\(String(describing: Auth.auth().currentUser?.uid))")
                                default:
                                    break
                                    
                                }
                            default:
                                break
                            }
                        }
                    )
                    .frame(width: 250, height: 45, alignment: .center)
                    .padding(.bottom, 5)
                    googleSignInButton
                        .padding(.vertical, 5)
                    signInWithFacebook
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
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
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
    
    private var googleSignInButton: some View {
        Button(action: {
            signInWithGoogle()
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
    
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { [self] user, err in
            if err != nil {
                print("Error Description: \(err?.localizedDescription)")
              return
            }

            guard
              let authentication = user?.authentication,
              let idToken = authentication.idToken
            else {
              return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { result, err in
                if err != nil {
                    print("Error Description: \(err?.localizedDescription)")
                  return
                }
                guard let user = result?.user else { return }
                print(user.displayName ?? "Sccuessful Sign In")
            }
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
    
    private var customDivider: some View {
        RoundedRectangle(cornerRadius: 1)
            .frame(height: 2)
    }
    
    private var signInWithFacebook: some View {
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

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
