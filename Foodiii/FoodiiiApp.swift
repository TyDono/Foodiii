//
//  FoodiiiApp.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/27/22.
//

import SwiftUI
import Firebase
import SwiftUI
import UserNotifications
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
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
        
        guard let user = user, let authentication = user.authentication, let idToken = authentication.idToken, let accessToken = authentication.accessToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        session.signInWithCredential(credential: credential) { [self] result, error in
            if error != nil, let error = error {
                session.alertItem = AlertItem(title: Text("Error Signing In With Google"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
                return
            }
            
            if let result = result {
                let id = result.user.uid
                let firstName = user.profile.givenName ?? ""
                let lastName = user.profile.familyName ?? ""
                let email = user.profile.email ?? ""
                let user = User(id: id, firstName: firstName, lastName: lastName, email: email)
                handleAddingUserToDatabase(user)
            }
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
