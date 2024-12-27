//
//  Project16_HotProspectsApp.swift
//  Project16-HotProspects
//
//  Created by suhail on 21/12/24.
//

import SwiftUI
import SwiftData

@main
struct Project16_HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
