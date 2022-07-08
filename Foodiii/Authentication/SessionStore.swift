//
//  SessionStore.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class SessionStore: ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    @Published var user: UserObservable? {
        didSet {
            self.didChange.send(self)
        }
    }
    @Published var isDoneSettingUp = false
    
    @Published var resetPasswordEmail = ""
    @Published var resetOobCode = ""
    @Published var isShowingResetPasswordView = false
    
    @Published var alertItem: AlertItem?
    
    
    func listen() {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { [self] (auth, authUser) in
            if authUser != nil, let userId = auth.currentUser?.uid {
//                // if we have a user, create a new user model
                user = UserObservable()
                user?.setId(to: userId)
            } else {
                user = nil
            }
            
            isDoneSettingUp = true
        }
    }
    
    //@escapin use swift closure syntax instead
//    func signUp(email: String, password: String, handler: @escaping (_ done: Bool)) {
//        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
//    }
//    
//    func signIn(email: String, password: String, handler: @escaping (Result<User, Error>) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
//    }
//    
//    func signInWithCredential(credential: AuthCredential, handler: @escaping (Result<User, Error>) -> Void) {
//        Auth.auth().signIn(with: credential, completion: handler)
//    }
    
    func signOut(completion: ((Error?) -> Void)) {
        do {
            try Auth.auth().signOut()
            user = nil
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}
