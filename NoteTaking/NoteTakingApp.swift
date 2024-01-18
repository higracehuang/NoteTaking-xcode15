//
//  NoteTakingApp.swift
//  NoteTaking
//
//  Created by Le Huang on 1/18/24.
//

import SwiftUI

@main
struct NoteTakingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
