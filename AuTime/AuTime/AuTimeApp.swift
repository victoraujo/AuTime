//
//  AuTimeApp.swift
//  AuTime
//
//  Created by Victor Vieira on 07/07/21.
//

import SwiftUI

@main
struct AuTimeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
