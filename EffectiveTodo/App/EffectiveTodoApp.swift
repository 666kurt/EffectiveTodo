//
//  EffectiveTodoApp.swift
//  EffectiveTodo
//
//  Created by Максим Шишлов on 20.11.2024.
//

import SwiftUI

@main
struct EffectiveTodoApp: App {
    var body: some Scene {
        WindowGroup {
            TodoScreen()
                .preferredColorScheme(.dark)
        }
    }
}
