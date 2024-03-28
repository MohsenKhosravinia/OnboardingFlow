//
//  ContentView.swift
//  Flow
//
//  Created by Mohsen Khosravinia on 3/28/24.
//

import SwiftUI
import Observation

struct LayoutLabel: Identifiable, Hashable {
    var id: String { labelText }
    var labelText: String
    var labelSize: CGSize
    var labelOffset: CGSize
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(labelText)
    }
}

struct LayoutLine: Identifiable {
    let id = UUID()
    var lineStartX: CGFloat
    var lineEndX: CGFloat
    var isLineForward: Bool
    var lineYOffset: CGFloat
    let width: CGFloat = 1
}

struct ViewData: Identifiable {
    var id: LayoutLabel { label }
    let index: Int
    let label: LayoutLabel
    let line: LayoutLine
    
    static func ==(lhs: ViewData, rhs: ViewData) -> Bool {
        lhs.label.id == rhs.label.id
    }
}

@Observable
final class ViewModel {
    var views: [ViewData] = []
    
    init() {
        setup()
    }
    
    func setup() {
        let firstLabel = LayoutLabel(
            labelText: "time to get\nrefreshed",
            labelSize: .zero,
            labelOffset: .zero
        )
        let firstLine = LayoutLine(
            lineStartX: 165,
            lineEndX: 235,
            isLineForward: true, 
            lineYOffset: -10
        )
        let first = ViewData(
            index: 0,
            label: firstLabel,
            line: firstLine
        )
        views.append(first)
        
        let secondLabel = LayoutLabel(
            labelText: "research",
            labelSize: .zero,
            labelOffset: .init(width: 85, height: -40)
        )
        let secondLine = LayoutLine(
            lineStartX: 75,
            lineEndX: 150,
            isLineForward: false, 
            lineYOffset: -60
        )
        let second = ViewData(
            index: 1,
            label: secondLabel,
            line: secondLine
        )
        views.append(second)
        
        let thirdLabel = LayoutLabel(
            labelText: "design",
            labelSize: .zero,
            labelOffset: .init(width: 155, height: -90)
        )
        let thirdLine = LayoutLine(
            lineStartX: 270,
            lineEndX: 190,
            isLineForward: true,
            lineYOffset: -108
        )
        let third = ViewData(
            index: 2,
            label: thirdLabel,
            line: thirdLine
        )
        views.append(third)
        
        let fourthLabel = LayoutLabel(
            labelText: "apply",
            labelSize: .zero,
            labelOffset: .init(width: 100, height: -140)
        )
        let fourthLine = LayoutLine(
            lineStartX: 95,
            lineEndX: 230,
            isLineForward: false,
            lineYOffset: -156
        )
        let fourth = ViewData(
            index: 3,
            label: fourthLabel,
            line: fourthLine
        )
        views.append(fourth)
    }
}

struct ContentView: View {
    let vm = ViewModel()
    @State private var animationProgress: CGFloat = 0.0
    @State private var buttonOpacity: CGFloat = 0.0
    private let animationDuration: TimeInterval = 0.5
    private let curveHeight: CGFloat = 130
    private var curveRadius: CGFloat { curveHeight / 2 }
    private let tintColor: Color = .white
    private let lineWidth: CGFloat = 2
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .zero) {
                    ForEach(vm.views) { view in
                        Text(view.label.labelText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .font(.system(size: 40, weight: .thin))
                            .offset(
                                x: view.label.labelOffset.width,
                                y: view.label.labelOffset.height
                            )
                        
                        CapsuleLine(
                            radius: curveRadius,
                            startX: view.line.lineStartX,
                            endX: view.line.lineEndX,
                            forward: view.line.isLineForward
                        )
                        .trim(from: 0.0, to: animationProgress)
                        .stroke(tintColor, lineWidth: view.line.width)
                        .animation(
                            Animation
                                .easeIn(duration: animationDuration)
                                .delay(Double(view.index) * animationDuration),
                            value: animationProgress
                        )
                        .frame(width: .infinity, height: curveHeight)
                        .onAppear {
                            withAnimation {
                                animationProgress = 1.0
                            }
                        }
                        .offset(y: view.line.lineYOffset)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            print("Tapped")
                        } label: {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                    }
                    .offset(y: CGFloat(vm.views.count * -45))
                    .padding(.horizontal)
                    .opacity(buttonOpacity)
                    .animation(Animation.easeOut(duration: animationDuration).delay(Double(vm.views.count) * animationDuration),
                    value: animationProgress)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: animationDuration)
                            .delay(Double(vm.views.count) * animationDuration)
                        ) {
                            buttonOpacity = buttonOpacity == 1.0 ? .zero : 1.0
                        }
                    }
                }
                .foregroundStyle(Color.white)
                .padding(.horizontal, 20)
            }
        }
        .background {
            Color.mint.ignoresSafeArea(edges: .all)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ViewPreference: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> Value) {}
}

extension View {
    func getSize(size: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color(uiColor: UIColor.systemBrown.withAlphaComponent(CGFloat.random(in: 0...1)))
                    .preference(key: ViewPreference.self, value: proxy.size)
            }
        )
        .onPreferenceChange(ViewPreference.self, perform: size)
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
        path.move(to: CGPoint(x: min(startX, rect.width - radius), y: 0))
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
}
