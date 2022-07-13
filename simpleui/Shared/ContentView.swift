//
//  ContentView.swift
//  Shared
//
//  Created by Nikolay.Igotti on 03.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 2.0
    var body: some View {
        Text("Hello, world!: \(count)")
            .padding()
        Button("Click me") {
            print("Button tapped!")
            count+=1
        }
        .scaleEffect(count)
        .animation(
            .linear(duration: 1)
            .repeatForever(autoreverses: true),
            value: count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
