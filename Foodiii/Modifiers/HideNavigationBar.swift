//
//  HideNavigationBar.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import Foundation
import SwiftUI

struct HideNavigationBarModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle("")
    }

}
