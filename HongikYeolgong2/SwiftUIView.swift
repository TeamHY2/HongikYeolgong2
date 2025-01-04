//
//  SwiftUIView.swift
//  HongikYeolgong2
//
//  Created by 권석기 on 12/22/24.
//

import SwiftUI
import ComposableArchitecture

struct SwiftUIView: View {
    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        OnboardingView(store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        })
    }
}

#Preview {
    SwiftUIView()
}
