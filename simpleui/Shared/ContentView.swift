//
//  ContentView.swift
//  Shared
//
//  Created by Nikolay.Igotti on 03.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    var body: some View {
        Text("Hello, world!: \(count)")
            .padding()
        Button("Click me") {
            print("Button tapped!")
            count+=1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
