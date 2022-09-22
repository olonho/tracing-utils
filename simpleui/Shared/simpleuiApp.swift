//
//  simpleuiApp.swift
//  Shared
//
//  Created by Nikolay.Igotti on 03.07.2022.
//

import SwiftUI

@main
struct simpleuiApp: App {
    @State private var current: Int = 10
    var body: some Scene {
        WindowGroup {
            //DrawingView(current: $current)
            //ContentView()
            //ImageBackgroundView()
            Animation4()
        }
    }
}
