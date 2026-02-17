//
//  TokeiApp.swift
//  とけいであそぼ
//

import SwiftUI
import SwiftData

@main
struct TokeiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ChildProfile.self, SkillMastery.self])
    }
}
