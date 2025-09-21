//
//  GoldenGaiGuideApp.swift
//  GoldenGaiGuide
//
//  Created by Shuhei Kinugasa on 2025/09/21.
//

import SwiftUI

@main
struct GoldenGaiGuideApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
