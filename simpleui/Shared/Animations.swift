//
//  Animations.swift
//  simpleui
//
//  Created by Huawei on 20.09.2022.
//

import Foundation
import SwiftUI

struct Animation1: View {
    @State var enabled = true
    var body: some View {
        VStack {
            Rectangle()
                .fill(enabled ? Color.green : Color.red)
                .animation(.easeIn(duration: 3), value: enabled)
                .frame(width: .infinity, height: 50)
            Button("Click Me") {
                enabled.toggle()
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .clipShape(Capsule())
            Spacer()
        }
    }
}

struct Animation2: View {
    @State var enabled = true
    @State var opacity = 1.0
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.red.opacity(opacity))
                .frame(width: .infinity, height: 50)
            Button("Click Me") {
                enabled.toggle()
                withAnimation(.easeIn(duration: 3)) {
                    opacity = enabled ? 1 : 0
                }
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .clipShape(Capsule())
            Spacer()
        }
    }
}

struct Animation3: View {
    @State var currentPage = 0
    @State var enabled = true
    @State var pageEnabled = 0
    @State var pageDisabled = 0
    var body: some View {
        VStack {
            if (enabled){
                ColorBoxTextOnly(value: currentPage)
                    .transition(.asymmetric(insertion: .opacity, removal: .slide))
                    .zIndex(1)
            } else {
                ColorBoxTextOnly(value: currentPage)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .top)))
                    .zIndex(1)
            }
            Button("Click Me") {
                enabled.toggle()
                currentPage = Int.random(in: 0...0xFFFFFF)
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .clipShape(Capsule())
        }
    }
}

struct ColorBoxTextOnly: View {
    let value: Int
    var body: some View {
        let color = Color.init(
            .sRGB,
            red: Double((value >> 16) & 0xff) / 255,
            green: Double((value >> 8) & 0xff) / 255,
            blue: Double((value) & 0xff) / 255,
            opacity: 1)
        Text(String(format:"%06X", value))
            .frame(width: 150, height: 150)
            .background(color)
//            .animation(.easeInOut(duration: 1), value: value)
    }
}

