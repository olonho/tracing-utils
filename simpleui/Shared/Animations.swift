//
//  Animations.swift
//  simpleui
//
//  Created by Huawei on 20.09.2022.
//

import Foundation
import SwiftUI

private func intAsColor(value: Int) -> Color {
    return Color.init(
        .sRGB,
        red: Double((value >> 16) & 0xff) / 255,
        green: Double((value >> 8) & 0xff) / 255,
        blue: Double((value) & 0xff) / 255,
        opacity: 1)
}

private func intAsHex(value: Int) -> String {
    return String(format:"%06X", value)
}

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
                    Text(intAsHex(value: page))
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
                    color = intAsColor(value: value)
                }
            }
        }
    }
}

struct Animation4: View {
    @State var enabled = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Image(enabled ? "img" : "ic_launcher_background")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 100, maxWidth: enabled ? nil : 150,
                           minHeight: 100, maxHeight: enabled ? nil : 150)
                    .background(Color.yellow)
                ClickMe {
                    withAnimation(.easeOut(duration: 1.5)) {
                        enabled.toggle()
                    }
                }
            }
            Spacer()
        }
    }
}

// Animation5 - It is hard to define sequence of animations

// Animation6 - There is no access to EnterExitState

struct Animation7: View {
    @State var enabled = true
    var body: some View {
        VStack {
            if (enabled) {
                Text("Hello, World!")
                    .transition(.move(edge: .top))
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
                    .transition(.move(edge: .top))
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
                        .transition(.opacity.combined(with: .move(edge: .top)))
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

struct AnimatedBox: View {
    @Binding var enabled: Bool
    var animation: Animation
    var body: some View {
        ZStack {
            GeometryReader { metrics in
                Color.red
                    .frame(width: 30, height: 30)
                    .offset(x: enabled ? metrics.size.width - 30 : 0, y: 0)
                    .animation(enabled ? animation : .default, value: enabled)
            }
        }
        .background(Color.yellow)
        .frame(width: nil, height: 30)
        .padding()
    }
}

struct Animation10: View {
    @State var enabled = false
    var body: some View {
        VStack {
            // there is no ability to use the same ways to init animation as in Compose
            Text("easeIn(duration: 1)")
            AnimatedBox(enabled: $enabled, animation: .easeIn(duration: 1))
            Text("interactiveSpring()")
            AnimatedBox(enabled: $enabled, animation: .interactiveSpring())
            Text("interpolatingSpring(stiffness: 10, damping: 3)")
            AnimatedBox(enabled: $enabled, animation: .interpolatingSpring(stiffness: 20, damping: 3))
            ClickMe {
                enabled.toggle()
            }
        }
    }
}

struct Animation11: View {
    @State private var pages: [Int] = [0]
    var body: some View {
        VStack {
            ForEach(pages, id: \.self) { page in // show received results
                let color = intAsColor(value: page)
                Text(intAsHex(value: page))
                    .foregroundColor(color)
                    .colorInvert()
                    .frame(width: 150, height: 150)
                    .background(color)
                    .transition(.opacity)
            }
            ClickMe {
                let value = Int.random(in: 0...0xFFFFFF)
                withAnimation(.easeInOut(duration: 1)) {
                    pages.removeAll()
                    pages.append(value)
                }
            }
        }
    }
}

struct Animation12: View {
    @State var enabled = false
    var body: some View {
        VStack {
            let border = enabled ? 5.0 : 20.0
            let color = enabled ? Color.secondary : Color.primary
            let rect = enabled
            ? CGRect(x: 100, y: 100, width: 300, height: 300)
            : CGRect(x: 0, y: 0, width: 100, height: 100)
            Canvas { context, size in
                // unfortunately the canvas does not support animation
                // note that rect and color are animated outside this scope
                context.fill(Path(rect), with: .color(color))
            }
            .frame(width: nil, height: 500)
            .border(.green, width: border)
            ClickMe {
                withAnimation {
                    enabled.toggle()
                }
            }
        }
    }
}
