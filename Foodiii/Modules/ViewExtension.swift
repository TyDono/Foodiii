//
//  ViewExentsion.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import Foundation
import SwiftUI

extension View {
    
    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
    
//    func hideNavigationBar() -> some View {
//        modifier(HideNavigationBarModifier())
//    }
    
}
