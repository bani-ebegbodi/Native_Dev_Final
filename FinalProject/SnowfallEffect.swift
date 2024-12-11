//
//  SnowfallEffect.swift
//  FinalProject
//
//  Created by Banibe Ebegbodi on 12/9/24.
//

import SwiftUI

//To improve my app, CHATGPT said I should have a snowfall effect so I applied it to all my game views 

struct SnowfallEffect: View {
    @State private var flakeYPosition: CGFloat = -100
    private let flakeSize: CGFloat = CGFloat.random(in: 18...40)
    private let flakeColor: Color = Color(
        red: Double.random(in: 0.6...1),
        green: Double.random(in: 0.7...1),
        blue: Double.random(in: 1...1),
        opacity: Double.random(in: 0.4...0.7)
    )
    private let animationDuration: Double = Double.random(in: 5...12)
    private let flakeXPosition: CGFloat = CGFloat.random(in: 0...UIScreen.main.bounds.width)

    var body: some View {
        Text("❄️")
            .font(.system(size: flakeSize))
            .foregroundColor(flakeColor)
            .position(x: flakeXPosition, y: flakeYPosition)
            .onAppear {
                withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                    flakeYPosition = UIScreen.main.bounds.height + 50
                }
            }
    }
}

#Preview {
    SnowfallEffect()
}
