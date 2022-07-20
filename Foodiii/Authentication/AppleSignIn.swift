//
//  AppleSignIn.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerPresentationContextProviding {

    let session: SessionStore
    let scenes = UIApplication.shared.connectedScenes

    @ObservedObject var user = UserObservable()


    init(session: SessionStore) {
        self.session = session
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window!
//        if #available(iOS 15, *) {
//            return UIWindowScene.windows.first!
//        } else {
//            return windowScene
//            return UIApplication.shared.windows.first!
//        }
    }

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

@available(iOS 13.0, *)
extension SignInWithAppleCoordinator: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)

            let firstName = appleIDCredential.fullName?.givenName ?? ""
            let lastName = appleIDCredential.fullName?.familyName ?? ""
            let email = appleIDCredential.email ?? ""

            session.signInWithCredential(credential: credential) { [self] result, error in
                if let error = error {
                    session.alertItem = AlertItem(title: Text("Error Signing In With Apple"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
                    return
                }

                if let result = result {
                    let id = result.user.uid
                    let user = User(id: id, firstName: firstName, lastName: lastName, email: email)
                    handleAddingUserToDatabase(user)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        session.alertItem = AlertItem(title: Text("Error Signing In With Apple"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
    }

    private func handleAddingUserToDatabase(_ user: User) {
        Firestore.firestore().collection("users").getDocuments() { [self] (querySnapshot, error) in
            if let error = error {
                session.alertItem = AlertItem(title: Text("Error Saving Data"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
                return
            }

            var userIDs: [String] = []

            for document in querySnapshot!.documents {
                if let id = document.get("id") as? String {
                    userIDs.append(id)
                }
            }

            if !userIDs.contains(user.id) {
                session.user?.isNewUser = true
                Analytics.logEvent(AnalyticsEvents.signUpWithApple, parameters: nil)
                saveUserInfoInDatabase(user)
                notificationSignup()
            } else {
                Analytics.logEvent(AnalyticsEvents.logInWithApple, parameters: nil)
            }
        }
    }

    private func saveUserInfoInDatabase(_ user: User) {
        let path = Firestore.firestore().collection("users").document(user.id)

        do {
//            try path.setData(from: user)
            saveUserToUserDefaults(user: user)
        } catch let error {
            session.alertItem = AlertItem(title: Text("Error Saving Data"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
        }
    }

    private func saveUserToUserDefaults(user newUser: User) {
        user.id = newUser.id
        user.firstName = newUser.firstName
        user.lastName = newUser.lastName
        user.email = newUser.email
        user.location = newUser.location
        user.profileImageUrl = newUser.profileImageUrl
    }

    func notificationSignup() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let imageURLString = ""
        let message: String = AppDelegate.foodiUserSignupNotificationGreeting
        let notification = FoodiNotification(type: .foodiNotification,
                                          imageUrl: imageURLString,
                                          message: message,
                                          datePosted: Date().dateToUTC,
                                          intelId: "edit_user_profile")
        let notificationPath: DocumentReference
        notificationPath = Firestore.firestore().collection("users").document(userId).collection("notifications").document(notification.id)
        let values: [String: Any] = [
            "id": notification.id,
            "type": notification.type.rawValue,
//            "image_url": notification.imageUrl,
            "message": notification.message,
            "is_read": notification.isRead
        ]
        notificationPath.setData(values)
    }

}

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
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
