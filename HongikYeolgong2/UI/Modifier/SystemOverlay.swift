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
                transaction.disablesAnimations = true
            }
    }
}

struct SystemOverlayZstck<ContentView: View>: ViewModifier {
    @Binding var isPresented: Bool
    let contentView: () -> ContentView
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .overlay(
                    Group {
                        if isPresented {
                            ZStack {
                                Color.black.opacity(0.75)
                                    .edgesIgnoringSafeArea(.all)
                                    .onTapGesture { isPresented = false }
                                contentView()
                            }
                            .transition(.opacity) // 애니메이션 적용 가능
                            .animation(.easeInOut, value: isPresented)
                        }
                    }
                )
        }
    }
}

extension View {
    func systemOverlay<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        modifier(SystemOverlay(isPresented: isPresented, contentView: content))
    }
    
    func systemOverlayZstck<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        modifier(SystemOverlayZstck(isPresented: isPresented, contentView: content))
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
