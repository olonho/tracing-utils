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

var x = 10

struct DrawingView: UIViewRepresentable {
    @Binding var current: Int
    
    private let view = UIView()

    var layer: CALayer? {
        view.layer
    }
    
    var shapeLayer: CAShapeLayer = CAShapeLayer()

    func makeUIView(context: Context) -> UIView {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            current = (current + 2) % 100
        }
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 50).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(shapeLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("updateUIView ", current)
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 64 + current, y: 64 + current, width: 160, height: 160), cornerRadius: 50).cgPath
    }
}
