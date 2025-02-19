//
//  SystemOverlay.swift
//  HongikYeolgong2
//
//  Created by 권석기 on 10/27/24.
//

import SwiftUI

struct SystemOverlay<ContentView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let contentView: () -> ContentView
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                ZStack {
                    Color.black.opacity(0.75).ignoresSafeArea(.all)
                    contentView()                        
                }
                .background(ClearBackgroundView())
            }
            .transaction { transaction in
                transaction.disablesAnimations = isPresented
            }
    }
}

extension View {
    func systemOverlay<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        modifier(SystemOverlay(isPresented: isPresented, contentView: content))
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            superview?.superview?.backgroundColor = .clear
        }
        
    }
}
