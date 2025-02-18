//
//  SharedView.swift
//  HongikYeolgong2
//
//  Created by 최주원 on 2/18/25.
//

import SwiftUI

struct SharedView: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    var image: UIImage
    
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Spacer()
                // 닫기 버튼
                Button {
                    isPresented.toggle()
                    //dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15.adjustToScreenWidth, height: 15.adjustToScreenHeight)
                        .foregroundStyle(.gray100)
                }
                .padding(.vertical, 14.adjustToScreenHeight)
            }
            
            Text("열공 기록을 공유해보세요!")
                .font(.pretendard(size: 16, weight: .bold), lineHeight: 26)
                .foregroundStyle(.gray100)
            
            
            Spacer()
                .frame(height: 12.adjustToScreenHeight)
            
            // 미리보기 이미지
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
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
            
            
            Spacer()
                .frame(height: 20.adjustToScreenHeight)
            
            // 하단 버튼
            HStack(spacing: 10.adjustToScreenWidth) {
                // 이미지 저장 버튼
                Button {
                    saveImage()
                } label: {
                    HStack(spacing: 4){
                        Image(.downloadSimple)
                        Text("이미지 저장")
                            .font(.pretendard(size: 16, weight: .semibold))
                            .foregroundStyle(.gray100)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 52.adjustToScreenHeight)
                    .background(.gray800)
                    .cornerRadius(4)
                }

                // 인스타 공유 버튼
                Button {
                    shareToInstagram()
                } label: {
                    HStack(spacing: 4){
                        Image(.instagramLogo)
                        Text("인스타 공유")
                            .font(.pretendard(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 52.adjustToScreenHeight)
                    .background(.blue100)
                    .cornerRadius(4)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 32.adjustToScreenWidth)
        .background {
            Image(.recordShareBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
                //.frame(maxWidth: .infinity)
        }
    }
    
    /// 이미지 저장
    func saveImage() {
        
    }
    
    /// 인스타 공유
    func shareToInstagram() {
        
    }
}
