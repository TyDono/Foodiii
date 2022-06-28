//
//  FontModifier.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/28/22.
//

import Foundation
import SwiftUI

struct FontModifier: ViewModifier {
    
    enum FontWeight {
        case bold, extraBold, regular, semiBold
    }
    
    var size: CGFloat
    var weight: FontWeight
    
    func body(content: Content) -> some View {
        switch weight {
        case .bold:
            return content.font(.custom("OpenSans-Bold", size: size))
        case .extraBold:
            return content.font(.custom("OpenSans-ExtraBold", size: size))
        case .regular:
            return content.font(.custom("OpenSans-Regular", size: size))
        case .semiBold:
            return content.font(.custom("OpenSans-SemiBold", size: size))
        }
    }
    
}
