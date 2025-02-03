//
//  RecordCell.swift
//  HongikYeolgong2
//
//  Created by 최주원 on 11/5/24.
//

import SwiftUI

struct RecordCell: View {
    let markImage: Image
    let title: String
    let hours: Int
    let minutes: Int
    
    var body: some View {
        VStack(alignment: .center ,spacing: 8.adjustToScreenHeight) {
            HStack(spacing: 2.adjustToScreenWidth){
                markImage
                Text(title)
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundStyle(.gray200)
            }
            
            Text("\(hours)H \(minutes)M")
                .font(.pretendard(size: 16, weight: .bold))
                .foregroundStyle(.gray100)
            
        }
        .frame(maxWidth: .infinity, maxHeight: 88.adjustToScreenHeight)
        .background(
            
            LinearGradient(
                colors: [
                    Color(.sRGB, red: 18/255, green: 20/255, blue: 24/255, opacity: 1),
                    Color(.sRGB, red: 20/255, green: 24/255, blue: 33/255, opacity: 1)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color(.sRGB, red: 82/255, green: 82/255, blue: 82/255, opacity: 1),
                            Color(.sRGB, red: 60/255, green: 60/255, blue: 60/255, opacity: 1),
                            Color(.sRGB, red: 46/255, green: 46/255, blue: 46/255, opacity: 1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    , lineWidth: 1)
        )
    }
}

