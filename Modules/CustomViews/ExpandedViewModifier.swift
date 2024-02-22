//
//  ExpandedViewModifier.swift
//  Nasa
//
//  Created by DAVID ODIA on 13/10/2023.
//

import SwiftUI

struct ExpandedViewModifier: ViewModifier {
    let height: CGFloat
    let width: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(
                maxWidth: width,
                maxHeight: height
            )
            .onAppear {
                withAnimation(.spring(duration: 0.55)) {}
            }
    }
}

struct TextOpacityViewModifier: ViewModifier {
    @State var opacityValue: Double
    var duration: Double
  
    func body(content: Content) -> some View {
        content
            .opacity(opacityValue)
            .onAppear {
                withAnimation(.easeIn(duration: duration)) {
                    self.opacityValue = opacityValue == 0 ? 1 : 0
                }
            }
    }
}

extension AnyTransition {
    static func expand(from: CGSize, to: CGSize) -> AnyTransition {
        return AnyTransition.modifier(
            active: ExpandedViewModifier(height: from.height, width: from.width),
            identity: ExpandedViewModifier(height: to.height, width: from.width)
        )
    }

  static func show(to: Double, animationDuration: Double) -> AnyTransition {
        return AnyTransition.modifier(
          active: TextOpacityViewModifier(opacityValue: to, duration: animationDuration),
            identity: TextOpacityViewModifier(opacityValue: 1, duration: animationDuration)
        )
    }
}

