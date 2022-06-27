//
//  FoodiiiApp.swift
//  Foodiii
//
//  Created by Tyler Donohue on 6/27/22.
//

import SwiftUI

@main
struct FoodiiiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
