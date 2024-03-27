//
//  ContentView.swift
//  Flow
//
//  Created by Mohsen Khosravinia on 3/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var animationProgress: CGFloat = 0.0
    private let animationDuration: TimeInterval = 1
    private let curveHeight: CGFloat = 130
    private let offset: CGFloat = -25
    private let tintColor: Color = .white
    private let lineWidth: CGFloat = 2

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .zero) {
                    Text("time to get\nrefreshed")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .font(.system(size: 40, weight: .thin))
                        .frame(height: 100)
                    
                    CapsuleLine(
                        radius: curveHeight / 2,
                        startX: 180,
                        endX: 240
                    )
                    .trim(from: 0.0, to: animationProgress)
                    .stroke(tintColor, lineWidth: lineWidth)
                    .animation(
                        Animation.easeIn(duration: animationDuration), value: animationProgress
                    )
                    .frame(width: .infinity, height: curveHeight)
                    .onAppear {
                        withAnimation {
                            animationProgress = 1.0
                        }
                    }
                    .offset(CGSize(width: 0, height: offset))
                    
                    
                    
                    Text("research")
                        .font(.system(size: 40, weight: .thin))
                        .offset(CGSize(width: 85.0, height: 2 * offset))
                    
                    CapsuleLine(
                        radius: curveHeight / 2,
                        startX: 80,
                        endX: 150,
                        forward: false
                    )
                    .trim(from: 0.0, to: animationProgress)
                    .stroke(tintColor, lineWidth: lineWidth)
                    .animation(
                        Animation.linear(duration: animationDuration).delay(animationDuration),
                        value: animationProgress
                    )
                    .frame(width: .infinity, height: curveHeight)
                    .onAppear {
                        withAnimation {
                            animationProgress = 1.0
                        }
                    }
                    .offset(CGSize(width: 0, height: 3 * offset))
                    
                    
                    
                    Text("design")
                        .font(.system(size: 40, weight: .thin))
                        .offset(CGSize(width: 160, height: 4 * offset))
                    
                    CapsuleLine(
                        radius: curveHeight / 2,
                        startX: 280,
                        endX: 170
                    )
                    .trim(from: 0.0, to: animationProgress)
                    .stroke(tintColor, lineWidth: lineWidth)
                    .animation(
                        Animation.linear(duration: animationDuration).delay(2 * animationDuration),
                        value: animationProgress
                    )
                    .frame(width: .infinity, height: curveHeight)
                    .onAppear {
                        withAnimation {
                            animationProgress = 1.0
                        }
                    }
                    .offset(CGSize(width: 0, height: 5 * offset))
                    
                    
                    
                    Text("apply")
                        .font(.system(size: 40, weight: .thin))
                        .offset(CGSize(width: 70, height: 6 * offset))
                    
                    CapsuleLine(
                        radius: curveHeight / 2,
                        startX: 60,
                        endX: 220,
                        forward: false
                    )
                    .trim(from: 0.0, to: animationProgress)
                    .stroke(tintColor, lineWidth: lineWidth)
                    .animation(
                        Animation.easeOut(duration: animationDuration).delay(3 * animationDuration),
                        value: animationProgress
                    )
                    .frame(width: .infinity, height: curveHeight)
                    .onAppear {
                        withAnimation {
                            animationProgress = 1.0
                        }
                    }
                    .offset(CGSize(width: 0, height: 7 * offset))
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 20)
            }
        }
        .background {
            Color.black.ignoresSafeArea(edges: .all)
        }
        .navigationTitle("Flow")
        .tint(Color.white)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CapsuleLine: Shape {
    let radius: CGFloat
    let startX: CGFloat
    let endX: CGFloat
    let forward: Bool
    
    init(
        radius: CGFloat,
        startX: CGFloat,
        endX: CGFloat,
        forward: Bool = true
    ) {
        self.radius = radius
        self.startX = startX
        self.endX = endX
        self.forward = forward
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: startX, y: 0))
        path.addLine(to: CGPoint(x: forward ? (rect.width - radius) : radius, y: 0))
        path.addArc(
            center: CGPoint(x: forward ? rect.width - radius : radius, y: radius),
            radius: radius,
            startAngle: Angle(degrees: 270),
            endAngle: Angle(degrees: 90),
            clockwise: !forward
        )
        path.addLine(to: CGPoint(x: max(endX, radius), y: radius * 2))
        return path
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .navigationTitle("Test")
}
