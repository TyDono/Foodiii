//
//  FoodiiiApp.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/27/22.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import GoogleSignIn
import SwiftUI
import UserNotifications
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var session = SessionStore()
    static let foodiUserSignupNotificationGreeting: String = "Welcome "
    @ObservedObject var user = UserObservable()
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            session.alertItem = AlertItem(title: Text("Error Signing In With Google"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
            return
        }
        let authentication = user.authentication
        let accessToken = authentication.accessToken
        guard let user = user, let idToken = authentication.idToken  else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        session.signInWithCredential(credential: credential) { [self] result, error in
            if error != nil, let error = error {
                session.alertItem = AlertItem(title: Text("Error Signing In With Google"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
                return
            }
            
            if let result = result {
                let id = result.user.uid
                let firstName = user.profile?.givenName ?? ""
                let lastName = user.profile?.familyName ?? ""
                let email = user.profile?.email ?? ""
                let user = User(id: id, firstName: firstName, lastName: lastName, email: email)
                handleAddingUserToDatabase(user)
            }
        }
    }
    
    func notificationSignup() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let imageURLString = "" //add a image url string here from firebase
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
            "image_url": notification.imageUrl,
            "message": notification.message,
            "date_posted": notification.datePosted,
            "intel_id": notification.intelId,
            "is_read": notification.isRead
        ]
        notificationPath.setData(values)
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
                Analytics.logEvent(AnalyticsEvents.signUpWithGoogle, parameters: nil)
                saveUserInfoInDatabase(user)
                notificationSignup()
            } else {
                Analytics.logEvent(AnalyticsEvents.logInWithGoogle, parameters: nil)
            }
        }
    }
    
    private func saveUserInfoInDatabase(_ user: User) {
        let path = Firestore.firestore().collection("users").document(user.id)
        
        do {
//            try path.setData(from: user) //ser data givving an error
//            add a save user to defaults here if wanted later on // won't need probably. rmeinder to add here is wanted after mvp
        } catch let error {
            session.alertItem = AlertItem(title: Text("Error Saving Data"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
        }
    }
    
}

@main
struct FoodiiiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationLogInView()
                .environmentObject(UserAuth())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
