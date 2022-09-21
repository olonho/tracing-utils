//
//  Animations.swift
//  simpleui
//
//  Created by Huawei on 20.09.2022.
//

import Foundation
import SwiftUI

private struct ClickMe: View {
    let action: () -> Void
    var body: some View {
        Button("Click Me", action: action)
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

struct Animation1: View {
    @State var enabled = true
    var body: some View {
        VStack {
            Rectangle()
                .fill(enabled ? Color.green : Color.red)
                .animation(.easeIn(duration: 3), value: enabled)
                .frame(width: nil, height: 50)
            ClickMe {
                enabled.toggle()
            }
            Spacer()
        }
    }
}

struct Animation2: View {
    @State var enabled = true
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.red)
                .opacity(enabled ? 1 : 0)
                .animation(.easeIn(duration: 3), value: enabled)
                .frame(width: nil, height: 50)
            ClickMe {
                enabled.toggle()
            }
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
            ClickMe {
                let value = Int.random(in: 0...0xFFFFFF)
                withAnimation(.easeInOut(duration: 1)) {
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
        }
    }
}

struct Animation7: View {
    @State var enabled = true
    var body: some View {
        VStack {
            if (enabled) {
                Text("Hello, World!")
                    .transition(.asymmetric(
                        insertion: .move(edge: .top),
                        removal: .move(edge: .top)))
            }
            ClickMe {
                withAnimation(.easeOut(duration: 1.5)) {
                    enabled.toggle()
                }
            }
        }
        .clipped()
    }
}

struct Animation8: View {
    @State var enabled = false
    @State var text = "Hello, World!"
    var body: some View {
        VStack {
            if (enabled) {
                Text(text)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top),
                        removal: .move(edge: .top)))
            }
            ClickMe {
                text = enabled ? "Disappearing" : "Appearing"
                if (!enabled) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        // this is not a good solution, see the best one here
                        // https://www.avanderlee.com/swiftui/withanimation-completion-callback/
                        text = "Hello, World!"
                    }
                }
                withAnimation(.easeOut(duration: 1.5)) {
                    enabled.toggle()
                }
            }
        }
        .clipped()
        .onAppear{
            withAnimation(.easeOut(duration: 1.5)) {
                enabled = true
            }
        }
    }
}

struct Animation9: View {
    @State var enabled = true
    var body: some View {
        VStack {
            ZStack {
                if (enabled) {
                    Text("Hello, world!")
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity.combined(with: .move(edge: .top))))
                }
            }
            .frame(width: nil, height: 20)
            ClickMe {
                withAnimation(.easeOut(duration: 1.5)) {
                    enabled.toggle()
                }
            }
        }
        .clipped()
    }
}
