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
    @State private var color = Color.black
    @State private var pages: [Int] = [0]
    var body: some View {
        VStack {
            ZStack {
                ForEach(pages, id: \.self) { page in // show received results
                    Text(String(format:"%06X", page))
                        .foregroundColor(color)
                        .colorInvert()
                        .frame(width: 150, height: 150)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .trailing)),
                            removal: .opacity.combined(with: .move(edge: .top))))
                }
            }
            .frame(width: 150, height: 150)
            .background(color)
            .clipped()
            Button("Click Me") {
                withAnimation(.easeInOut(duration: 1)) {
                    let value = Int.random(in: 0...0xFFFFFF)
                    pages.removeAll()
                    pages.append(value)
                    color = Color.init(
                        .sRGB,
                        red: Double((value >> 16) & 0xff) / 255,
                        green: Double((value >> 8) & 0xff) / 255,
                        blue: Double((value) & 0xff) / 255,
                        opacity: 1)
                }
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .clipShape(Capsule())
        }
    }
}

