//
//  ContentView.swift
//  Shared
//
//  Created by Nikolay.Igotti on 03.07.2022.
//

import SwiftUI

struct ImageBackgroundView: View {
    @State private var index = 0

    private let images: [Image] = ["trash", "star", "circle", "circle.fill", "square", "cloud"].map{ Image(systemName: $0) }
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ForEach(images.indices, id: \.self) { imageIndex in
                    self.images[imageIndex]
                        .resizable()
                        .transition(.slide)
                        .opacity(imageIndex == self.index ? 1.0 : 0.0)
                }
            }
            .onReceive(timer) { _ in
                withAnimation {
                    self.index = self.index < self.images.count - 1 ? self.index + 1 : 0
                }
            }
        }
}

struct ContentView: View {
    @State var scale = 1.0
    var animation: Animation {
        Animation.easeInOut
        .repeatForever(autoreverses: false)
    }
    var body: some View {
        VStack(alignment: .center) {
            Button("Hello") {}
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 8)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    withAnimation(repeated) {
                        scale = 2.5
                    }
                }
                .foregroundColor(Color.white)
                .background(Color.blue)
                .scaleEffect(scale, anchor: .leading)
                .transition(.opacity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DrawingView: UIViewRepresentable {
    @Binding var current: Int
    
    private let view = UIView()

    var layer: CALayer? {
        view.layer
    }
    
    var shapeLayer: CAShapeLayer = CAShapeLayer()

    func makeUIView(context: Context) -> UIView {
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            current = (current + 2) % 100
        }
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 50).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(shapeLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        //print("updateUIView ", current)
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 64 + current, y: 64 + current, width: 120 + Int(current % 70), height: 160), cornerRadius: 20.0 + CGFloat(current % 50)).cgPath
    }
}
